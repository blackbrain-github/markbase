// Packages
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImportantButton extends HookWidget {
  final Function onPressed;
  final String title;
  final bool selected;
  final bool disabled;
  final bool isAsync;
  final bool big;
  final bool maxRoundedCorners;

  const ImportantButton({
    required this.onPressed,
    required this.title,
    this.selected = true,
    this.disabled = false,
    this.isAsync = false,
    this.big = false,
    this.maxRoundedCorners = false,
  });

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.theme,
      builder: (_) => CustomAnimatedWidget(
        onPressed: () async {
          if (disabled == false) await onPressed();
        },
        isAsync: isAsync,
        child: Container(
          height: big ? 40 : 34,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.selectedButtonColor : AppColors.getUnselectedButtonColor(),
            borderRadius: BorderRadius.circular(maxRoundedCorners
                ? 100
                : big
                    ? 15
                    : 12),
          ),
          child: CustomText(
            title,
            size: 16,
            fontWeight: FontWeight.w700,
            customColor: selected ? AppColors.selectedButtonTextColor : AppColors.unselectedButtonTextColor,
          ),
        ),
        loadingWidget: Transform.scale(
          scale: 0.9,
          child: Container(
            height: big ? 40 : 34,
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.getSecondaryBackgroundColor(),
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
