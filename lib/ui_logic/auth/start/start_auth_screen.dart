import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart' as Common;
import 'package:Markbase/ui_logic/common/widgets/buttons/custom_button.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StartAuthScreen extends HookWidget {
  const StartAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthLogic logic = AuthLogic();

    return Screen(
      child: Column(
        children: [
          const Spacer(),
          Common.CommonLogic.theme.get == Common.Theme.light
              ? Image.asset(
                  'assets/logos/markbase-full-logo-light.png',
                  height: 30,
                )
              : Image.asset(
                  'assets/logos/markbase-full-logo-dark.png',
                  height: 30,
                ),
          const Spacer(flex: 4),
          CustomText(
            "By signing up, you agree to Markbase's policies and terms. To learn more, visit markba.se/policies",
            customColor: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
            fontWeight: FontWeight.w600,
            softWrap: true,
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: () => logic.signUpWithEmail(context),
            title: 'Sign up with email',
            icon: Icon(
              Icons.email_rounded,
              size: 24,
              color: Common.CommonLogic.theme.get == Common.Theme.light ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: () => logic.continueWithGoogle(),
            title: 'Continue with Google',
            icon: Image.asset('assets/icons/google-icon.png', height: 24, width: 24),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CustomText('Already have an account?', color: TextColorType.secondary),
              const SizedBox(width: 5),
              CustomAnimatedWidget(onPressed: () => logic.logInWithEmail(context), child: const CustomText('Log in', color: TextColorType.accent)),
            ],
          ),
        ],
      ),
    );
  }
}
