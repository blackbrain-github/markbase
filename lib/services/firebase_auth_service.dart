// Packages
import 'package:Markbase/ui_logic/common/common_logic.dart';
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
      print(e);
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
    } on FirebaseAuthException {
      /*
        A [FirebaseAuthException] maybe thrown with the following error code:

        *email-already-in-use:
        Thrown if there already exists an account with the given email address.
        *invalid-email:
        Thrown if the email address is not valid.
        *operation-not-allowed:
        Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
        *weak-password:
        Thrown if the password is not strong enough.
      */
      rethrow;
    } catch (e) {
      throw _error("Error signing up with email");
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
}
