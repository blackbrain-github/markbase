import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/user.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/settings/settings_screen_logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          child: StreamBuilder(
            stream: Database.get.userAsStream(),
            builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> doc) {
              if (doc.data != null) {
                UserModel userModel = UserModel.fromMap(doc.data!.data()!);
                return Container(
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
                            child: userModel.profileImageUrl != ''
                                ? Image.network(
                                    userModel.profileImageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Container(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          userModel.username,
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
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}
