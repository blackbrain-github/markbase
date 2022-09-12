import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/ui_logic/auth/email_auth_screen/email_auth_screen.dart';
import 'package:Markbase/ui_logic/auth/widgets/icon_log_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContinueWithEmailButton extends HookWidget {
  const ContinueWithEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconLogInButton(
      function: () {
        Navigate(context).to(EmailAuthScreen());
      },
      title: "Sign in with email",
    );
  }
}
