import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/sign_up/sign_up_screen_create_profile.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreenConfirmEmail extends StatefulWidget {
  final AuthLogic logic;
  final String email;
  final String password;
  const SignUpScreenConfirmEmail(this.logic, {required this.email, required this.password, Key? key}) : super(key: key);

  @override
  State<SignUpScreenConfirmEmail> createState() => _SignUpScreenConfirmEmailState();
}

class _SignUpScreenConfirmEmailState extends State<SignUpScreenConfirmEmail> {
  bool emailSent = false;
  String errorMesssage = '';
  String announcment = '';

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'Sign up',
      subtitle: 'Enter password',
      children: [
        CustomButton(
          onPressed: () async {
            List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(widget.email);
            if (signInMethods.isEmpty || signInMethods.isNotEmpty && emailSent) {
              if (!emailSent) {
                try {
                  await widget.logic.signUpWithEmailAndConfirmEmail(context, widget.email, widget.password);
                } catch (e) {
                  setState(() => errorMesssage = '$e');
                }
                setState(() => emailSent = true);
              } else {
                await FirebaseAuth.instance.currentUser?.reload();
                if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                  Navigate(context).to(SignUpScreenCreateProfile(widget.logic));
                } else {
                  setState(() => errorMesssage = 'Email not verified');
                }
              }
            } else {
              if (signInMethods.contains('password')) {
                setState(() => announcment = 'Email is used for another account, please sign in');
              }
              if (signInMethods.contains('google.com')) {
                setState(() => announcment = 'Sign in with Google to continue');
              }
            }
          },
          title: emailSent ? 'Continue' : 'Send email verification',
          isAsync: true,
        ),
        if ((emailSent && errorMesssage == '' && announcment == '') || errorMesssage != '' || announcment != '') const SizedBox(height: 10),
        if (emailSent && errorMesssage == '' && announcment == '') const CustomText('Email sent, also check your spam', customColor: Color(0xFF28F95E)),
        if (errorMesssage != '') CustomText(errorMesssage, customColor: Colors.red),
        if (announcment != '') CustomText(announcment, customColor: const Color(0xFF28F95E)),
        const SizedBox(height: 20),
        Center(
          child: CustomAnimatedWidget(
            onPressed: () async {
              if (!emailSent) {
                int popsLeft = 3;
                Navigator.of(context).popUntil((_) {
                  popsLeft -= 1;
                  return popsLeft == 0;
                });
              } else {
                try {
                  await FirebaseAuth.instance.currentUser?.reload();
                  if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                    setState(() => announcment = 'Email already verified');
                  }

                  await widget.logic.sendEmailConfirmation();

                  setState(() => errorMesssage = '');
                  setState(() => announcment = 'Email sent again');
                  setState(() => emailSent = true);
                } catch (e) {
                  setState(() => errorMesssage = 'Something went wrong');
                }
              }
            },
            child: CustomText((!emailSent) ? 'Entered email wrong?' : 'Resend', color: TextColorType.accent, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
