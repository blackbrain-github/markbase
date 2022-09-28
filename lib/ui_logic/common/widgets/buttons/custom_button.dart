// Packages
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart' as Common;
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomButton extends HookWidget {
  final Function onPressed;
  final String title;
  final bool selected;
  final bool disabled;
  final bool isAsync;
  final bool big;
  final bool maxRoundedCorners;
  final Widget? icon;
  final Common.Theme? theme;

  const CustomButton({
    required this.onPressed,
    required this.title,
    this.selected = true,
    this.disabled = false,
    this.isAsync = false,
    this.big = false,
    this.maxRoundedCorners = false,
    this.icon,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: Common.CommonLogic.theme,
      builder: (_) => CustomAnimatedWidget(
        onPressed: () async {
          if (disabled == false) await onPressed();
        },
        isAsync: isAsync,
        child: Container(
          height: 40,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.getNoteColor(theme: theme),
            border: Border.all(
              color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.1),
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
              ),
            ],
          ),
        ),
        loadingWidget: Transform.scale(
          scale: 0.9,
          child: Container(
            height: 40,
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.getNoteColor(theme: theme),
              border: Border.all(
                color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.1),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(maxRoundedCorners
                  ? 100
                  : big
                      ? 15
                      : 12),
            ),
            child: const MarkbaseLoadingWidget(small: true),
          ),
        ),
      ),
    );
  }
}
