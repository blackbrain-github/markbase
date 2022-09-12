import 'package:Markbase/ui_logic/auth/continue_with_email_button.dart';
import 'package:Markbase/ui_logic/auth/continue_with_google_button.dart';
import 'package:Markbase/ui_logic/common/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        children: const [
          Text(
            "Beatle",
            style: TextStyle(
              fontFamily: "All Round Gothic",
              fontWeight: FontWeight.w700,
              fontSize: 60,
              color: Colors.black,
            ),
          ),
          Spacer(),
          ContinueWithGoogleButton(),
          SizedBox(height: 10),
          ContinueWithEmailButton(),
        ],
      ),
    );
  }
}
