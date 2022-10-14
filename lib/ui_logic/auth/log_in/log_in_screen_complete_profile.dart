import 'dart:io';

import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/services/functions.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/sign_up/widgets/add_profile_photo.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:flutter/material.dart';

class SignInScreenCompleteProfile extends StatefulWidget {
  final AuthLogic logic;
  final String? displayName;
  const SignInScreenCompleteProfile(this.logic, {this.displayName, Key? key}) : super(key: key);

  @override
  State<SignInScreenCompleteProfile> createState() => _SignInScreenCompleteProfileState();
}

class _SignInScreenCompleteProfileState extends State<SignInScreenCompleteProfile> {
  late final TextEditingController fullName;
  late final TextEditingController username;
  File? profileImage;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fullName = TextEditingController();
    username = TextEditingController();
    if (widget.displayName != null) {
      fullName.text = widget.displayName!;
    }
  }

  @override
  void dispose() {
    fullName.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'One last step',
      subtitle: 'Add profile',
      children: [
        Expanded(
          child: Center(
            child: AddProfilePhoto(
              getProfileImage: (File file) => profileImage = file,
            ),
          ),
        ),
        const SizedBox(height: 15),
        CustomIndependentTextField(
          title: 'Enter full name',
          controller: fullName,
        ),
        const SizedBox(height: 10),
        CustomIndependentTextField(
          title: 'Enter username',
          controller: username,
        ),
        const SizedBox(height: 10),
        if (errorMessage != '') CustomText(errorMessage, customColor: Colors.red),
        if (errorMessage != '') const SizedBox(height: 10),
        CustomButton(
          onPressed: () async {
            setState(() => errorMessage = '');
            if (fullName.text == '') {
              setState(() => errorMessage = 'Full name is required');
            } else if (username.text == '') {
              setState(() => errorMessage = 'Username is required');
            } else if (await Functions.isUsernameAvailable(username.text) == false) {
              setState(() => errorMessage = 'Username is taken');
            } else {
              try {
                await widget.logic.createUserProfile(context, fullName.text, username.text, profileImage);
                CommonLogic.appUser.set(await Database.get.user());
                Navigate(context).to(const Master());
              } catch (e) {
                setState(() {
                  errorMessage = 'Something went wrong';
                });
              }
            }
          },
          title: 'Continue',
          isAsync: true,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
