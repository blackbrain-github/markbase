// Packages
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static FlutterError _error(String e) {
    return FlutterError('FirebaseAuth error: e');
  }

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in/up with Google
  static Future<UserCredential> continueWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();

      if (_googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await _googleUser.authentication;

        List<String> existingSignInMethods = await _auth.fetchSignInMethodsForEmail(_googleUser.email);

        // Create a new credential
        final _credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        //now link these credentials with the existing user
        UserCredential userCredential = await _auth.signInWithCredential(_credential);

        CommonLogic.isLoggedIn.set(true, notify: false);

        return userCredential;
      } else {
        throw _error("Failed signing in with Google");
      }
    } catch (e) {
      throw _error("Failed signing in with Google");
    }
  }

  // Sign up with email and password
  static Future<UserCredential> signUpWithEmail({required String email, required String password}) async {
    try {
      UserCredential _credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      CommonLogic.isLoggedIn.set(true, notify: false);

      return _credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email is used for another account';
      } else if (e.code == 'invalid-email') {
        throw 'Email is not valid';
      } else if (e.code == 'operaation-not-allowd') {
        throw 'Something went wrong';
      } else if (e.code == 'weak-password') {
        throw 'Something went wrong';
      }
      throw 'Something went wrong';
    }
  }

  // Sign in with email and password
  static Future<UserCredential> signInWithEmail({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      CommonLogic.isLoggedIn.set(true, notify: false);

      return userCredential;
    } on FirebaseAuthException {
      /*
        A [FirebaseAuthException] maybe thrown with the following error code:

        *invalid-email:
        Thrown if the email address is not valid.
        *user-disabled:
        Thrown if the user corresponding to the given email has been disabled.
        *user-not-found:
        Thrown if there is no user corresponding to the given email.
        *wrong-password:
        Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set. 
      */
      rethrow;
    } catch (e) {
      throw _error("Error signing in with email");
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      CommonLogic.isLoggedIn.set(false, notify: false);
    } catch (e) {
      throw _error("Failed signing out");
    }
  }

  // Reset password
  static Future<void> sendPasswordResetLink(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> sendEmailConfirmation({UserCredential? userCredential}) async {
    if (userCredential != null) {
      userCredential.user?.sendEmailVerification();
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      } else {
        throw 'user-not-signed-in';
      }
    }
  }
}
