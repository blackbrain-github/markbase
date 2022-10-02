import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/screen.dart';
import 'package:Markbase/ui_logic/auth/start/start_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AuthScreen extends HookWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  const AuthScreen({required this.title, required this.subtitle, required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAnimatedWidget(
              onPressed: () {
                Navigate(context).to(const StartAuthScreen(), ableToGoBack: false);
              },
              child: const CustomText('cancel', color: TextColorType.secondary)),
          const SizedBox(height: 25),
          CustomText(
            title,
            size: 24,
            fontWeight: FontWeight.w600,
            softWrap: true,
          ),
          CustomText(
            subtitle,
            size: 18,
            fontWeight: FontWeight.w500,
            customColor: const Color(0xFFACACAC),
            softWrap: true,
          ),
          const Spacer(),
          ...children,
        ],
      ),
    );
  }
}
