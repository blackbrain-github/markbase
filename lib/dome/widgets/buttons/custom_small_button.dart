// Packages
import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart' as Common;
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/services/app_vibrate.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common_widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomSmallButton extends HookWidget {
  final Function onPressed;
  final String title;
  final bool selected;
  final bool disabled;
  final bool isAsync;
  final Common.Theme? theme;
  final Color? textColor;

  const CustomSmallButton({
    required this.onPressed,
    required this.title,
    this.selected = true,
    this.disabled = false,
    this.isAsync = false,
    this.theme,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: Common.CommonLogic.theme,
      builder: (_) => CustomAnimatedWidget(
        onPressed: () async {
          AppVibrate.light();
          if (disabled == false) await onPressed();
        },
        isAsync: isAsync,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accentColor
                : Common.CommonLogic.theme.get == Common.Theme.light
                    ? const Color(0xFFE7E7E7)
                    : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(15),
            boxShadow: selected
                ? [
                    BoxShadow(color: AppColors.getShadowColor(theme: theme), blurRadius: 5),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                title,
                size: 16,
                fontWeight: FontWeight.w700,
                customColor: selected ? Colors.white : textColor ?? AppColors.getPrimaryTextColor().withOpacity(0.4),
              ),
            ],
          ),
        ),
        loadingWidget: Transform.scale(
          scale: 0.9,
          child: Container(
            height: 40,
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              border: Border.all(
                color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.1),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const MarkbaseLoadingWidget(small: true, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
