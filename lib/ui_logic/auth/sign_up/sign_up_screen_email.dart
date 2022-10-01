import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/sign_up/sign_up_screen_password.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SignUpScreenEmail extends StatefulWidget {
  final AuthLogic logic;
  const SignUpScreenEmail(this.logic, {Key? key}) : super(key: key);

  @override
  State<SignUpScreenEmail> createState() => _SignUpScreenEmailState();
}

class _SignUpScreenEmailState extends State<SignUpScreenEmail> {
  late final TextEditingController controller;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'Sign up',
      subtitle: 'Enter email',
      children: [
        CustomIndependentTextField(
          title: 'Enter email',
          controller: controller,
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        if (errorMessage != '') CustomText(errorMessage, customColor: Colors.red),
        if (errorMessage != '') const SizedBox(height: 10),
        CustomButton(
          onPressed: () {
            setState(() {
              errorMessage = '';
            });
            try {
              if (widget.logic.emailIsValid(controller.text)) {
                Navigate(context).to(SignUpScreenPassword(widget.logic, email: controller.text));
              }
            } catch (e) {
              setState(() {
                errorMessage = '$e';
              });
            }
          },
          title: 'Continue',
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
