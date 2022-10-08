import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/log_in/log_in_screen_password.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';

class LogInScreenEmail extends StatefulWidget {
  final AuthLogic logic;
  const LogInScreenEmail(this.logic, {Key? key}) : super(key: key);

  @override
  State<LogInScreenEmail> createState() => _LogInScreenEmailState();
}

class _LogInScreenEmailState extends State<LogInScreenEmail> {
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
      title: 'Log in',
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
            setState(() => errorMessage = '');
            try {
              if (widget.logic.emailIsValid(controller.text)) {
                Navigate(context).to(LogInScreenPassword(widget.logic, email: controller.text));
              }
            } catch (e) {
              setState(() => errorMessage = '$e');
            }
          },
          title: 'Continue',
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
