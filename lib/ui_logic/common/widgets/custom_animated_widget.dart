import 'package:flutter/material.dart';

class CustomAnimatedWidget extends StatefulWidget {
  final Function onPressed;
  final Function? onLongPress;
  final Function? onDoupleTap;
  final Widget child;
  final double endSize;
  final Function? onTapDown;
  final Function? onTapUp;
  final bool? isAsync;
  final Widget? loadingWidget;
  final bool animate;
  final bool fadeIn;

  const CustomAnimatedWidget({
    required this.onPressed,
    this.onLongPress,
    this.onDoupleTap,
    required this.child,
    this.endSize = 0.975,
    this.isAsync,
    this.loadingWidget,
    this.onTapDown,
    this.onTapUp,
    this.animate = true,
    this.fadeIn = true,
  });

  @override
  State<CustomAnimatedWidget> createState() => _CustomAnimatedWidgetState();
}

class _CustomAnimatedWidgetState extends State<CustomAnimatedWidget> with TickerProviderStateMixin {
  late final AnimationController _scaleAnimationController;
  late final Animation _scaleAnimation;
  late final AnimationController _fadeInAnimationController;
  late final Animation<double> _fadeInAnimation;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween(
      begin: 1.0,
      end: widget.endSize,
    ).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.decelerate,
      ),
    );

    _fadeInAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeInAnimationController,
        curve: Curves.ease,
      ),
    );

    _fadeInAnimationController.forward();
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _fadeInAnimationController.dispose();
    super.dispose();
  }

  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedBuilder(
          animation: _fadeInAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeInAnimation,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: GestureDetector(
                      onTap: () async {
                        if (widget.animate) await _scaleAnimationController.forward();
                        if (widget.isAsync != null) {
                          try {
                            setState(() {
                              _loading = true;
                            });
                            await widget.onPressed();
                            setState(() {
                              _loading = false;
                            });
                          } catch (e) {
                            setState(() {
                              _loading = false;
                            });
                          }
                        } else {
                          widget.onPressed();
                        }
                        if (widget.animate) _scaleAnimationController.reverse();
                      },
                      onTapDown: (s) {
                        if (widget.animate) _scaleAnimationController.forward();
                        if (widget.onTapDown != null) {
                          widget.onTapDown!();
                        }
                      },
                      onTapCancel: () {
                        if (widget.animate) _scaleAnimationController.reverse();
                      },
                      onTapUp: (s) {
                        if (widget.animate) _scaleAnimationController.reverse();
                        if (widget.onTapUp != null) {
                          widget.onTapUp!();
                        }
                      },
                      onLongPress: (widget.onLongPress != null)
                          ? () {
                              if (widget.onLongPress != null) {
                                widget.onLongPress!();
                              }
                            }
                          : null,
                      onDoubleTap: (widget.onDoupleTap != null) ? () {} : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (widget.isAsync != null)
                            Visibility(
                              child: widget.loadingWidget ?? Container(),
                              visible: _loading,
                            ),
                          Visibility(
                            child: widget.child,
                            visible: !_loading,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
