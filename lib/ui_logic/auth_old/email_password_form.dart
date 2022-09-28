import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/auth_old/auth_screen_logic.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/custom_button.dart';
import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmailPasswordForm extends HookWidget {
  final AuthScreenLogic logic;
  const EmailPasswordForm(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey<FormState>();
    FocusNode passwordFocus = useFocusNode();

    return Form(
      key: _key,
      child: Column(
        children: [
          CustomTextField(
            title: "email",
            validator: (String s) => logic.isValidEmail(s),
            onSaved: (s) => logic.email.set(s.replaceAll(" ", "")),
          ),
          Listen(
            to: logic.state,
            builder: (EnterEmailScreenState state) {
              if (state == EnterEmailScreenState.login) {
                passwordFocus.requestFocus();
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomTextField(
                      title: "password",
                      focusNode: passwordFocus,
                      obscureText: true,
                      validator: (String s) => logic.isPasswordValid(s),
                      onSaved: (s) {},
                    ),
                  ],
                );
              } else if (state == EnterEmailScreenState.signup) {
                passwordFocus.requestFocus();
                return ColumnWithSpacing(
                  d: 10,
                  children: [
                    const SizedBox(height: 10),
                    CustomTextField(
                      title: "password",
                      focusNode: passwordFocus,
                      obscureText: true,
                      validator: (String s) => logic.isPasswordValid(s),
                      onSaved: (s) => logic.password.set(s),
                    ),
                    CustomTextField(
                      title: "confirm password",
                      obscureText: true,
                      validator: (String s) => logic.isConfirmPasswordValid(s),
                      onSaved: (s) {},
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 10),
          Listen(
            to: logic.state,
            builder: (EnterEmailScreenState? state) {
              return CustomButton(
                onPressed: () async => logic.continueButton(_key, context),
                title: state == EnterEmailScreenState.signup
                    ? "Create account"
                    : state == EnterEmailScreenState.login
                        ? "Log in"
                        : "Continue",
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
