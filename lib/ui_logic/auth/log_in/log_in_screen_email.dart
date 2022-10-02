import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/log_in/log_in_screen_password.dart';
import 'package:Markbase/ui_logic/auth/reset_password.dart/reset_password_screen.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LogInScreenEmail extends HookWidget {
  final AuthLogic logic;
  const LogInScreenEmail(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = useTextEditingController();

    return AuthScreen(
      title: 'Log in',
      subtitle: 'Enter email',
      children: [
        CustomIndependentTextField(
          title: 'Enter email',
          controller: controller,
        ),
        const SizedBox(height: 10),
        CustomButton(
          onPressed: () {
            if (logic.emailIsValid(controller.text)) {
              Navigate(context).to(LogInScreenPassword(logic, email: controller.text));
            } else {}
          },
          title: 'Continue',
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
  }
}
