import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreenPassword extends StatefulWidget {
  final AuthLogic logic;
  final String email;
  const SignUpScreenPassword(this.logic, {required this.email, Key? key}) : super(key: key);

  @override
  State<SignUpScreenPassword> createState() => _SignUpScreenPasswordState();
}

class _SignUpScreenPasswordState extends State<SignUpScreenPassword> {
  late final TextEditingController password;
  late final TextEditingController confirmPassword;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'Sign up',
      subtitle: 'Enter password',
      children: [
        CustomIndependentTextField(
          title: 'Enter password',
          controller: password,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        CustomIndependentTextField(
          title: 'Confirm password',
          controller: confirmPassword,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        if (errorMessage != '') CustomText(errorMessage, customColor: Colors.red),
        if (errorMessage != '') const SizedBox(height: 10),
        CustomButton(
          onPressed: () async {
            setState(() {
              errorMessage = '';
            });
            try {
              if (widget.logic.passwordsAreValid(password.text, confirmPassword.text)) {
                await widget.logic.confirmEmailBeforeSigningUp(context, email: widget.email, password: password.text);
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
