import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/ui_logic/auth/log_in/log_in_screen.dart';
import 'package:Markbase/ui_logic/auth/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

class AuthLogic {
  void continueWithGoogle() {}

  void logInWithEmail(BuildContext context) {
    Navigate(context).to(LogInScreen(this));
  }

  void signUpWithEmail(BuildContext context) {
    Navigate(context).to(SignUpScreen(this));
  }
}
