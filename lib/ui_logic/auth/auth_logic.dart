import 'dart:io';

import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/services/firebase_auth_service.dart';
import 'package:Markbase/ui_logic/auth/log_in/log_in_screen_complete_profile.dart';
import 'package:Markbase/ui_logic/auth/sign_up/sign_up_screen_confirm_email.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthLogic {
  Future<void> continueWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuthService.continueWithGoogle();

      //await FirebaseAnalytics.instance.logLogin(loginMethod: "google");
      if (userCredential.additionalUserInfo?.isNewUser ?? true) {
        // New user
        Navigate(context).to(SignInScreenCompleteProfile(this));
      } else {
        try {
          await FirebaseAuth.instance.currentUser?.reload();
          var r = await Database.get.user();
          CommonLogic.appUser.set(r);
          Navigate(context).to(const Master(), ableToGoBack: false);
        } catch (e) {
          if (e == 'not-found') {
            // User has an account but no profile was created
            Navigate(context).to(SignInScreenCompleteProfile(this), ableToGoBack: false);
          }
        }
      }
    } catch (e) {
      Show(context).errorMessage(message: "Couldn't sign in with Google, try again later");
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuthService.signInWithApple();

      //await FirebaseAnalytics.instance.logLogin(loginMethod: "google");
      if (userCredential.additionalUserInfo?.isNewUser ?? true) {
        // New user
        Navigate(context).to(SignInScreenCompleteProfile(this));
      } else {
        try {
          await FirebaseAuth.instance.currentUser?.reload();
          var r = await Database.get.user();
          CommonLogic.appUser.set(r);
          Navigate(context).to(const Master(), ableToGoBack: false);
        } catch (e) {
          if (e == 'not-found') {
            // User has an account but no profile was created
            Navigate(context).to(SignInScreenCompleteProfile(this), ableToGoBack: false);
          }
        }
      }
    } catch (e) {
      Show(context).errorMessage(message: "Couldn't sign in with Apple, try again later");
    }
  }

  Future<void> logInWithEmail(BuildContext context, {required String email, required String password}) async {
    await FirebaseAuthService.signInWithEmail(email: email, password: password);
    await CommonLogic.getAppUser();
  }

  Future<void> signUpWithEmailAndConfirmEmail(BuildContext context, String email, String password) async {
    UserCredential userCredential = await FirebaseAuthService.signUpWithEmail(email: email, password: password);
    FirebaseAuthService.sendEmailConfirmation(userCredential: userCredential);
  }

  Future<void> sendEmailConfirmation() async {
    await FirebaseAuthService.sendEmailConfirmation();
  }

  Future<void> confirmEmailBeforeSigningUp(BuildContext context, {required String email, required String password}) async {
    Navigate(context).to(SignUpScreenConfirmEmail(this, email: email, password: password));
  }

  Future<void> createUserProfile(BuildContext context, String fullName, String username, File? profileImage) async {
    await Database.create.user(username, fullName, profileImage: profileImage);
  }

  // Validation
  bool emailIsValid(String email) {
    RegExp allowedCharacters = RegExp(r"""^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$""");
    if (!allowedCharacters.hasMatch(email)) {
      throw 'Not a valid email';
    }
    return true;
  }

  Future<void> sendResetPasswordLink(String email) async {
    await FirebaseAuthService.sendPasswordResetLink(email);
  }

  bool passwordsAreValid(String password, String confirmPassword) {
    RegExp allowedCharacters = RegExp(r"""^[\w\-\/:;\(\)$€&@"'\.\,\?!,\[\]\{\}#%\^*\+=_\\\|~<>£¥· ]+$""");
    RegExp specialCharacter = RegExp(r"""[0-9\-\/:;\(\)$€&@"'\.\,\?!,\[\]\{\}#%\^*\+=_\\\|~<>£¥·]""");

    if (!(password.length >= 8)) {
      throw 'Password must be at least 8 characters long';
    } else if (password.length > 128) {
      throw 'Password can only be 128 characters long';
    } else if (!allowedCharacters.hasMatch(password)) {
      throw 'Password contains invalid character';
    } else if (!specialCharacter.hasMatch(password)) {
      throw 'Password must contain at least one number or special character';
    } else if (password != confirmPassword) {
      throw "Passwords don't match";
    }
    return true;
  }
}
