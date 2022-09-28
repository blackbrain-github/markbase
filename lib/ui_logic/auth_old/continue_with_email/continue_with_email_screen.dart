import 'package:Markbase/ui_logic/auth_old/auth_screen_logic.dart';
import 'package:Markbase/ui_logic/auth_old/email_password_form.dart';
import 'package:Markbase/ui_logic/common/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContinueWithEmail extends HookWidget {
  final AuthScreenLogic logic;
  const ContinueWithEmail(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Continue with email',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          EmailPasswordForm(logic),
        ],
      ),
    );
  }
}
