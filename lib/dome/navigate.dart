import 'package:flutter/material.dart';

class Navigate {
  final BuildContext context;
  Navigate(this.context);

  /// Navigate to screen with push. Set 'ableToGoBack' to false if
  /// you want to prevent the user from going back to previous screen.
  Future<dynamic> to(Widget screen, {bool ableToGoBack = true}) async {
    if (ableToGoBack) {
      var result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen),
      );
      return result;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen),
        (route) => false,
      );
    }
  }

  /* class AppNavigator {
  // Screen is a scaffold
  void showSheet(BuildContext context, Widget screen) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.1),
      enableDrag: true,
      builder: (context) => screen,
    );
  }

  void goTo(BuildContext context, Widget newScreen, String title, {bool expensive = false, bool pauseWhenPushed = true}) {
    Widget backButton() {
      return CustomAnimatedWidget(
        onPressed: () {
          Navigator.maybePop(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
          ),
        ),
      );
    }

    if (pauseWhenPushed) {
      CommonLogic.audioPlayer.pause();
    }

    Navigator.push(
      context,
      Platform.isAndroid
          ? PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => newScreen,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: Scaffold(
                    body: Stack(
                      children: [
                        newScreen,
                        Positioned(
                          top: MediaQuery.of(context).viewPadding.top + 15,
                          left: 15,
                          child: backButton(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Stack(
                  children: [
                    newScreen,
                    Positioned(
                      top: MediaQuery.of(context).viewPadding.top + 15,
                      left: 15,
                      child: backButton(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Small info popup that can be dismissed
  void showInfoPopup(BuildContext context, String title, {String? description}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (c) {
        return CustomPopup(
          title: title,
          description: description ?? "",
          buttonTitle: "Ok",
          buttonFunction: () => Navigator.of(context).maybePop(),
        );
      },
    );
  }

  void showActionPopup(BuildContext context, List<Widget> widgets, Function onTap) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).colorScheme.background,
      builder: (c) {
        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width - 34,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets
                ..addAll(
                  [
                    ContentSpacer(d: 15),
                    ImportantButton(
                      function: () async {
                        await onTap();
                        Navigator.of(context).maybePop();
                      },
                      title: "Done",
                    ),
                    ContentSpacer(d: 5),
                  ],
                ),
            ),
          ),
        );
      },
    );
  }

  void showPartScreenPopup(BuildContext context, Widget child, {Color backgroundColor = Colors.white, Color barrierColor = Colors.black38}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      barrierColor: barrierColor,
      builder: (context) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).viewPadding.top + 80,
            20,
            MediaQuery.of(context).viewPadding.bottom + 20,
          ),
          child: child,
        );
      },
    );
  }

  /// Show bottom sheet
  

  static void pushToScreenWithoutTopBar(BuildContext context, Widget newScreen, {bool expensive = false}) {
    CommonLogic.audioPlayer.pause();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 500)),
            // This is to prevent animation lag when page is being built
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContentSpacer(d: 10),
                        Expanded(
                          child: newScreen,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Scaffold(
                body: Center(
                  child: MarkbaseLoadingWidget(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static void replaceScreen(BuildContext context, Widget newScreen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: SafeArea(child: newScreen),
          );
        },
      ),
    );
  }
} */
}
