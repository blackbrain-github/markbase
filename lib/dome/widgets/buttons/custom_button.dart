// Packages
import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart' as Common;
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common_widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomButton extends HookWidget {
  final Function onPressed;
  final String title;
  final bool selected;
  final bool disabled;
  final bool isAsync;
  final bool maxRoundedCorners;
  final Widget? icon;
  final Common.Theme? theme;
  final Color color;
  final Color? textColor;
  final bool unfavorableOption;

  const CustomButton({
    required this.onPressed,
    required this.title,
    this.selected = true,
    this.disabled = false,
    this.isAsync = false,
    this.maxRoundedCorners = false,
    this.icon,
    this.theme,
    this.color = AppColors.accentColor,
    this.textColor,
    this.unfavorableOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: Common.CommonLogic.theme,
      builder: (_) => CustomAnimatedWidget(
        onPressed: () async {
          if (disabled == false) {
            if (isAsync) {
              await onPressed();
            } else {
              onPressed();
            }
          }
        },
        isAsync: isAsync,
        child: Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: unfavorableOption ? Colors.transparent : color,
            border: Border.all(
              color: unfavorableOption ? AppColors.accentColor : AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.2),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: AppColors.getShadowColor(theme: theme), blurRadius: 5)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) icon!,
              if (icon != null) const SizedBox(width: 10),
              CustomText(
                title,
                size: 16,
                fontWeight: FontWeight.w700,
                customColor: textColor ?? Colors.white,
              ),
            ],
          ),
        ),
        loadingWidget: Transform.scale(
          scale: 0.95,
          child: Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              border: Border.all(
                color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.1),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(maxRoundedCorners ? 100 : 15),
            ),
            child: const MarkbaseLoadingWidget(small: true, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
