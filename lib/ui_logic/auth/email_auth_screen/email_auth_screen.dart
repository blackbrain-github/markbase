import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/ui_logic/auth/email_password_form.dart';
import 'package:Markbase/ui_logic/common/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'email_auth_screen_logic.dart';

class EmailAuthScreen extends HookWidget {
  const EmailAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EmailAuthScreenLogic logic = EmailAuthScreenLogic(
      context,
      email: VariableNotifier<String?>(null),
      password: VariableNotifier<String?>(null),
      state: VariableNotifier<EnterEmailScreenState>(EnterEmailScreenState.unknown),
    );

    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enter email"),
          const Spacer(),
          EmailPasswordForm(logic),
        ],
      ),
    );
  }
}
