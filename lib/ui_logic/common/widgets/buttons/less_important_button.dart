// Packages
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LessImportantButton extends StatelessWidget {
  final Function function;
  final String title;
  final Color? color;
  const LessImportantButton({required this.function, required this.title, this.color});

  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      onPressed: () {
        function();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.accentColor, width: 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: CustomText(
          title,
          color: TextColorType.accent,
          fontWeight: FontWeight.w500,
          size: 18,
        ),
      ),
    );
  }
}
