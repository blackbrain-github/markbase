// Packages
import 'dart:convert';
import 'dart:math';

import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error continuing with Google'));
      throw _error("Failed signing in with Google");
    }
  }

  static Future<UserCredential> signInWithApple() async {
    try {
      /// Generates a cryptographically secure random nonce, to be included in a
      /// credential request.
      String generateNonce([int length = 32]) {
        const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
      }

      /// Returns the sha256 hash of [input] in hex notation.
      String sha256ofString(String input) {
        final bytes = utf8.encode(input);
        final digest = sha256.convert(bytes);
        return digest.toString();
      }

      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      var userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      CommonLogic.isLoggedIn.set(true, notify: false);

      return userCredential;
    } catch (e) {
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error signing in with Apple'));
      throw _error("Failed signing in with Apple");
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
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error signing up with email'));
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
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error signing in with email'));
      throw _error("Error signing in with email");
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      CommonLogic.isLoggedIn.set(false, notify: false);
    } catch (e) {
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error signing out'));
      throw _error("Failed signing out");
    }
  }

  // Reset password
  static Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error sending password reset link'));
    }
  }

  static Future<void> sendEmailConfirmation({UserCredential? userCredential}) async {
    try {
      if (userCredential != null) {
        userCredential.user?.sendEmailVerification();
      } else {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        } else {
          throw 'user-not-signed-in';
        }
      }
    } catch (e) {
      FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Error sending email verification'));
    }
  }
}
