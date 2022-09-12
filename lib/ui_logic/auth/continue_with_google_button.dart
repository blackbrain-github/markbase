import 'package:Markbase/services/firebase_auth_service.dart';
import 'package:Markbase/ui_logic/auth/widgets/icon_log_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContinueWithGoogleButton extends HookWidget {
  const ContinueWithGoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconLogInButton(
      function: () async {
        try {
          UserCredential userCredential = await FirebaseAuthService.continueWithGoogle();
          //await FirebaseAnalytics.instance.logLogin(loginMethod: "google");
          if (userCredential.additionalUserInfo?.isNewUser ?? true) {
            // New user
            print("Is new user");
          } else {
            // Not new user
            print("Is not new user");
          }
        } catch (e) {
          print(e);
          // Show.errorMessage("Something went wrong trying to sign in with Google")
        }
      },
      logoPath: "assets/icons/sign_in/google_logo.svg",
      title: "Continue with Google",
    );
  }
}
