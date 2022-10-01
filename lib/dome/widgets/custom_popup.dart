import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';

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
          border: Border.all(
            width: 0.5,
            color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(title, size: 18, fontWeight: FontWeight.w600),
            if (description != "") const SizedBox(height: 5),
            if (description != "")
              CustomText(
                description,
                size: 16,
                softWrap: true,
                maxLines: 1,
              ),
            const SizedBox(height: 15),
            CustomButton(
              onPressed: () {
                if (buttonFunction != null) {
                  buttonFunction!();
                }
              },
              title: buttonTitle,
            ),
            const SizedBox(height: 10),
            if (button2Title != null)
              CustomButton(
                onPressed: () {
                  if (button2Function != null) {
                    button2Function!();
                  }
                },
                title: button2Title!,
                color: AppColors.accentColor.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
