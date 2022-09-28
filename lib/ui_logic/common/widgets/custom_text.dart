import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final TextColorType color;
  final Color? customColor;
  final Color? customLightModeColor;
  final Color? customDarkModeColor;
  final int? maxLines;
  final TextAlign textAlign;
  final bool softWrap;
  final bool underlined;

  const CustomText(
    this.text, {
    Key? key,
    this.size = 14,
    this.fontWeight = FontWeight.w500,
    this.color = TextColorType.primary,
    this.customColor,
    this.customLightModeColor,
    this.customDarkModeColor,
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
    this.underlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fontWeightAsFamily() {
      if (fontWeight == FontWeight.w300) {
        return "Light";
      } else if (fontWeight == FontWeight.w400) {
        return "Regular";
      } else if (fontWeight == FontWeight.w500) {
        return "Medium";
      } else if (fontWeight == FontWeight.w600) {
        return "SemiBold";
      } else if (fontWeight == FontWeight.w700) {
        return "Bold";
      } else if (fontWeight == FontWeight.w800) {
        return "ExtraBold";
      } else if (fontWeight == FontWeight.w900) {
        return "Black";
      }
      return "Medium";
    }

    return Listen(
      to: CommonLogic.theme,
      builder: (_) {
        return Text(
          text,
          style: TextStyle(
            color: (customColor != null)
                ? customColor
                : (customLightModeColor != null && customDarkModeColor != null)
                    ? AppVariables.appState.read('theme') == null
                        ? customLightModeColor
                        : AppVariables.appState.read('theme') == 'light'
                            ? customLightModeColor
                            : customDarkModeColor
                    : color == TextColorType.primary
                        ? AppColors.getPrimaryTextColor()
                        : color == TextColorType.secondary
                            ? AppColors.getSecondaryTextColor()
                            : color == TextColorType.inversePrimary
                                ? AppColors.getInversePrimaryTextColor()
                                : AppColors.accentColor,
            fontFamily: fontWeightAsFamily(),
            fontSize: size,
            overflow: TextOverflow.visible,
            decoration: underlined ? TextDecoration.underline : null,
          ),
          softWrap: softWrap,
          maxLines: maxLines,
          textAlign: textAlign,
        );
      },
    );
  }
}

enum TextColorType { primary, secondary, accent, inversePrimary }
