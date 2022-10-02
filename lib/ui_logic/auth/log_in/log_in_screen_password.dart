import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/log_in/log_in_screen_complete_profile.dart';
import 'package:Markbase/ui_logic/auth/reset_password.dart/reset_password_screen.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LogInScreenPassword extends HookWidget {
  final AuthLogic logic;
  final String email;
  const LogInScreenPassword(this.logic, {required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = useTextEditingController();
    bool passwordIsWrong = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AuthScreen(
          title: 'Log in',
          subtitle: 'Enter password',
          children: [
            CustomIndependentTextField(title: 'Enter password', obscureText: true, controller: controller),
            if (passwordIsWrong) const SizedBox(height: 5),
            if (passwordIsWrong) const CustomText('Password or email is wrong', customColor: Colors.red),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () async {
                try {
                  setState(() => passwordIsWrong = false);
                  await logic.logInWithEmail(
                    context,
                    email: email,
                    password: controller.text,
                  );

                  try {
                    await FirebaseAuth.instance.currentUser?.reload();
                    CommonLogic.appUser.set(await Database.get.user());
                  } catch (e) {
                    if (e == 'not-found') {
                      // User has an account but no profile was created
                      Navigate(context).to(SignInScreenCompleteProfile(logic));
                    }
                  }

                  Navigate(context).to(const Master(), ableToGoBack: false);
                } catch (e) {
                  setState(() => passwordIsWrong = true);
                }
              },
              title: 'Log in',
              isAsync: true,
            ),
            const SizedBox(height: 15),
            Center(
              child: CustomAnimatedWidget(
                onPressed: () => Navigate(context).to(ResetPasswordScreen(logic)),
                child: const CustomText('Forgot password?', color: TextColorType.accent, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }
}
