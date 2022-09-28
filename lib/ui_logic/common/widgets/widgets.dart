// Packages
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/less_important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

// CustomBottomSheet
class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final double minChildSize;
  final double maxChildSize;
  final double initialChildSize;

  const CustomBottomSheet(this.child, {this.minChildSize = 0.95, this.maxChildSize = 0.95, this.initialChildSize = 0.95});

  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    Widget _bar() {
      return Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 7,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(100),
        ),
      );
    }

    return SafeArea(
      child: DraggableScrollableSheet(
        maxChildSize: maxChildSize,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        builder: (context, controller) {
          return SafeArea(child: child);
        },
      ),
    );
  }
}

// Custom popup
class CustomPopup extends StatelessWidget {
  final String title;
  final String description;
  final String buttonTitle;
  final Function? buttonFunction;
  final String? button2Title;
  final Function? button2Function;

  const CustomPopup({
    required this.title,
    required this.description,
    required this.buttonTitle,
    this.buttonFunction,
    this.button2Title,
    this.button2Function,
  });

  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.getPrimaryBackgroundColor(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(title, size: 18, fontWeight: FontWeight.w600),
            if (description != "") const VerticalSpacer(d: 5),
            if (description != "")
              CustomText(
                description,
                size: 16,
                softWrap: true,
              ),
            const VerticalSpacer(d: 15),
            ImportantButton(
              onPressed: () {
                if (buttonFunction != null) {
                  buttonFunction!();
                }
              },
              title: buttonTitle,
            ),
            const VerticalSpacer(d: 10),
            if (button2Title != null)
              LessImportantButton(
                function: () {
                  if (button2Function != null) {
                    button2Function!();
                  }
                },
                title: button2Title!,
              ),
          ],
        ),
      ),
    );
  }
}

// No internet notification (in app)
class NoInternetNotification extends StatelessWidget {
  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomAnimatedWidget(
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          "No internet connection",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {},
      endSize: 0.8,
    ));
  }
}

// Custom text field

// Custom app bar

class Widgets {
  static AppBar customAppBar(final BuildContext context, final String title) {
    return AppBar(
      toolbarHeight: 45,
      backgroundColor: Colors.black,
      centerTitle: false,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: CustomAnimatedWidget(
        child: const Icon(
          Icons.keyboard_backspace_rounded,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Container(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
