import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LogoAndSettingsButton extends HookWidget {
  const LogoAndSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.theme,
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 26, color: Colors.black, fontFamily: 'ExtraBold'),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Markbase',
                      style: TextStyle(
                        color: AppColors.getPrimaryTextColor(),
                      )),
                  const TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: AppColors.accentColor,
                    ),
                  ),
                ],
              ),
            ),
            CustomAnimatedWidget(
              onPressed: () => Navigate(context).to(const SettingsScreen()),
              child: const CustomText(
                "Juuso",
                size: 18,
                fontWeight: FontWeight.w700,
                color: TextColorType.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
