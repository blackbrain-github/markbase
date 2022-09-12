import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/services/firebase_auth_service.dart';
import 'package:Markbase/ui_logic/complete_profile/complete_profile_screen.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuthScreenLogic {
  final BuildContext context;
  final VariableNotifier<String?> email;
  final VariableNotifier<String?> password;
  final VariableNotifier<EnterEmailScreenState> state; // 'unknown' or 'login' or 'signup'

  EmailAuthScreenLogic(
    this.context, {
    required this.email,
    required this.password,
    required this.state,
  });

  String? isValidEmail(String s) {
    if (s.isEmpty) {
      return "Field cannot be empty";
    } else if (!s.contains("@") || !s.contains(".") || s.characters.last == ".") {
      return "Email must be valid";
    } else {
      return null;
    }
  }

  String? isPasswordValid(String s) {
    // TODO Too much?

    if (s.isEmpty) {
      return "Field cannot be empty";
    } else if (s.length < 8) {
      return "Password must be at least 8 characters";
    } else if (s == s.toLowerCase()) {
      return "Password must contains at least one uppercase";
    } else {
      password.set(s);
      return null;
    }
  }

  String? isConfirmPasswordValid(String s) {
    if (s.isEmpty) {
      return "Field cannot be empty";
    } else if (password.get != s) {
      return "Password must match";
    } else {
      return null;
    }
  }

  Future<void> continueButton(GlobalKey<FormState> key) async {
    if (key.currentState?.validate() ?? false) {
      key.currentState?.save();

      // Check if user or not
      // TODO check null
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email.get!).then((List<String> signInMethods) async {
        if (signInMethods.contains('password')) {
          state.set(EnterEmailScreenState.login);

          if (email.get != null && password.get != null) {
            await logIn(email: email.get!, password: password.get!);
            Navigate(context).to(Master());
          }
        } else if (signInMethods.isEmpty) {
          state.set(EnterEmailScreenState.signup);

          if (email.get != null && password.get != null) {
            await signUp();
            Navigate(context).to(CompleteProfileScreen());
          }
        } else if (signInMethods.contains('google.com')) {
          // logic.promptGoogleSignIn
        }
      }).catchError((e) {
        print(e);
        Show(context).errorMessage();
      });
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await FirebaseAuthService.signInWithEmail(email: email, password: password);
    } catch (e) {
      Show(context).errorMessage();
    }
  }

  Future<void> signUp() async {
    try {
      // Reload just in case
      // TODO Check null
      await FirebaseAuthService.signUpWithEmail(
        email: email.get!,
        password: password.get!,
      );

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } on FirebaseException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          Show(context).errorMessage(message: "An account with email already exists");
          break;

        case "invalid-email":
          Show(context).errorMessage(message: "Email is not valid");
          break;

        case "weak-password":
          Show(context).errorMessage(message: "Password is too weak");
          break;

        default:
          Show(context).errorMessage();
          break;
      }
    } catch (e) {
      Show(context).errorMessage();
      rethrow;
    }
  }
}

enum EnterEmailScreenState { unknown, login, signup }
