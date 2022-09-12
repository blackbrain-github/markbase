import 'dart:io';

import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/ui_logic/common/widgets/screen.dart';
import 'package:Markbase/ui_logic/complete_profile/complete_profile_screen_logic.dart';
import 'package:Markbase/ui_logic/complete_profile/profile_details_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CompleteProfileScreen extends HookWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CompleteProfileScreenLogic logic = CompleteProfileScreenLogic(
      context,
      profileImage: VariableNotifier<File?>(null),
      username: VariableNotifier<String?>(null),
      loading: VariableNotifier<bool>(false),
    );

    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Complete profile"),
          const Spacer(),
          ProfileDetailsScreen(logic),
        ],
      ),
    );
  }
}
