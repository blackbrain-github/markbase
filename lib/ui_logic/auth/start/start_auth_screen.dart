import 'dart:io';

import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart' as Common;
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/screen.dart';
import 'package:Markbase/ui_logic/auth/auth_logic.dart';
import 'package:Markbase/ui_logic/auth/log_in/log_in_screen_email.dart';
import 'package:Markbase/ui_logic/auth/sign_up/sign_up_screen_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

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
                  'assets/logos/markbase-full-logo-black.png',
                  height: 30,
                )
              : Image.asset(
                  'assets/logos/markbase-full-logo-white.png',
                  height: 30,
                ),
          const Spacer(flex: 3),
          CustomText(
            "By signing up, you agree to Markbase's policies and terms. To learn more, visit markba.se/privacy-policy",
            customColor: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
            fontWeight: FontWeight.w600,
            softWrap: true,
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: () => Navigate(context).to(SignUpScreenEmail(logic)),
            title: 'Sign up with email',
            color: AppColors.getPrimaryBackgroundColor(),
            textColor: AppColors.getPrimaryTextColor(),
            icon: Icon(
              Icons.email_rounded,
              size: 24,
              color: Common.CommonLogic.theme.get == Common.Theme.light ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: () => logic.continueWithGoogle(context),
            title: 'Continue with Google',
            isAsync: true,
            color: AppColors.getPrimaryBackgroundColor(),
            textColor: AppColors.getPrimaryTextColor(),
            icon: Image.asset('assets/icons/google-icon.png', height: 24, width: 24),
          ),
          const SizedBox(height: 10),
          if (Platform.isIOS)
            CustomButton(
              onPressed: () async => await logic.signInWithApple(context),
              title: 'Sign in with Apple',
              isAsync: true,
              color: AppColors.getPrimaryBackgroundColor(),
              textColor: AppColors.getPrimaryTextColor(),
              icon: SvgPicture.asset(
                'assets/icons/apple-icon.svg',
                height: 24,
                width: 24,
                color: Common.CommonLogic.theme.get == Common.Theme.light ? Colors.black : Colors.white,
              ),
            ),
          if (Platform.isIOS) const SizedBox(height: 10),
          Row(
            children: [
              const CustomText('Already have an account?', color: TextColorType.secondary),
              const SizedBox(width: 5),
              CustomAnimatedWidget(
                onPressed: () => Navigate(context).to(LogInScreenEmail(logic)),
                child: const CustomText('Log in', color: TextColorType.accent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
