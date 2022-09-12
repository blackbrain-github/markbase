import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Screen extends HookWidget {
  final Widget child;
  final String? title;
  final Color? backgroundColor;
  const Screen({required this.child, this.title, this.backgroundColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.theme,
      builder: (_) {
        return Scaffold(
          backgroundColor: backgroundColor ?? AppColors.getPrimaryBackgroundColor(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null)
                    CustomText(
                      title!,
                      size: 22,
                      color: TextColorType.primary,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.start,
                    ),
                  const SizedBox(height: 15),
                  Expanded(child: child)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
