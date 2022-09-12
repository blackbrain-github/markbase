import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen_button.dart';
import 'package:Markbase/ui_logic/complete_profile/complete_profile_screen_logic.dart';
import 'package:Markbase/ui_logic/complete_profile/upload_profile_image_button.dart';
import 'package:Markbase/ui_logic/complete_profile/username_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfileDetailsScreen extends HookWidget {
  final CompleteProfileScreenLogic logic;
  const ProfileDetailsScreen(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UploadProfileImageButton(logic),
        const SizedBox(height: 10),
        UsernameField(logic),
        const SizedBox(height: 10),
        Listen(
          to: logic.username,
          builder: (String? username) {
            return AuthScreenButton(
              "Continue",
              () async => !(logic.username.get == null || logic.username.get == "") ? await logic.updateUsernameAndProfileImage() : {},
              disabled: (logic.username.get == null || logic.username.get == ""),
            );
          },
        ),
      ],
    );
  }
}
