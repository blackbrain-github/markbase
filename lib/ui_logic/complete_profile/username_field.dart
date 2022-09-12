import 'package:Markbase/ui_logic/common/widgets/custom_text_field.dart';
import 'package:Markbase/ui_logic/complete_profile/complete_profile_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UsernameField extends HookWidget {
  final CompleteProfileScreenLogic logic;
  const UsernameField(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: logic.usernameKey,
      child: CustomTextField(
        title: "username",
        onChanged: (s) => logic.username.set(s),
        validator: (String s) => logic.validUsername(s),
        onSaved: (s) => logic.username.set(s),
      ),
    );
  }
}
