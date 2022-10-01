// Packages
import 'package:Markbase/dome/app_specific/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MarkbaseLoadingWidget extends HookWidget {
  final bool small;
  final Color color;
  const MarkbaseLoadingWidget({this.small = false, this.color = AppColors.accentColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: small ? 20 : 30,
      width: small ? 20 : 30,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: color,
      ),
    );
  }
}

class WeirdLoadingWidget extends StatefulWidget {
  const WeirdLoadingWidget({Key? key}) : super(key: key);

  @override
  State<WeirdLoadingWidget> createState() => _WeirdLoadingWidgetState();
}

class _WeirdLoadingWidgetState extends State<WeirdLoadingWidget> with TickerProviderStateMixin {
  late final AnimationController _scaleAnimationController;
  late final Animation _scaleAnimation;

  final bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween(
      begin: 0.3,
      end: 0.7,
    ).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.ease,
        reverseCurve: Curves.easeInBack,
      ),
    );

    forward();
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }

  void forward() async {
    await _scaleAnimationController.forward().then((value) => _scaleAnimationController.reverse());
    forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: double.infinity,
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Container(
            width: (50 * _scaleAnimation.value).roundToDouble(),
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.accentColor,
            ),
          );
        },
      ),
    );
  }
}
