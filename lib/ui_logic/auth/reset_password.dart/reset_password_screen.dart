import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResetPasswordScreen extends HookWidget {
  final AuthLogic logic;
  const ResetPasswordScreen(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = useTextEditingController();
    bool errorSendingResetLink = false;
    bool successfullySentResetLink = false;
    bool couldNotFindUser = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AuthScreen(
          title: 'Reset password',
          subtitle: "Enter your email and we'll send you a link to reset your password",
          children: [
            CustomIndependentTextField(title: 'Enter email', controller: controller),
            if (errorSendingResetLink || successfullySentResetLink || couldNotFindUser) const SizedBox(height: 5),
            if (errorSendingResetLink) const CustomText('Error sending reset link', customColor: Colors.red),
            if (couldNotFindUser) const CustomText('We could not find an account with this email', customColor: Colors.red),
            if (successfullySentResetLink) const CustomText('Successfully sent reset link', customColor: Colors.green),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () async {
                setState(() {
                  successfullySentResetLink = false;
                  errorSendingResetLink = false;
                  couldNotFindUser = false;
                });
                try {
                  await logic.sendResetPasswordLink(controller.text);
                  setState(() => successfullySentResetLink = true);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() => couldNotFindUser = true);
                  } else {
                    setState(() => errorSendingResetLink = true);
                  }
                }
              },
              title: 'Send reset link',
              isAsync: true,
            ),
          ],
        );
      },
    );
  }
}
