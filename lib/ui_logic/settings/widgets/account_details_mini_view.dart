import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/settings/settings_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountDetailsMiniView extends HookWidget {
  final SettingsScreenLogic logic;
  const AccountDetailsMiniView(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
        to: CommonLogic.theme,
        builder: (_) {
          return CustomAnimatedWidget(
            onPressed: () => logic.seeAccountDetails(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getNoteColor(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: AppColors.getShadowColor(),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CommonLogic.appUser.get!.profileImageUrl != ''
                            ? Image.network(
                                CommonLogic.appUser.get!.profileImageUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CustomText(
                      CommonLogic.appUser.get!.username,
                      size: 18,
                      fontWeight: FontWeight.w600,
                      color: TextColorType.primary,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_right_rounded,
                      color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
