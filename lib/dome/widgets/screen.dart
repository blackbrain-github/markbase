import 'dart:io';

import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Screen extends HookWidget {
  final Widget child;
  final String? title;
  final Color? backgroundColor;
  final Color? titleColor;
  const Screen({
    required this.child,
    this.title,
    this.backgroundColor,
    this.titleColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.theme,
      builder: (_) {
        return Scaffold(
          backgroundColor: backgroundColor ?? AppColors.getPrimaryBackgroundColor(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, Platform.isAndroid ? 15 : 0, 15, Platform.isAndroid ? 15 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null)
                    CustomText(
                      title!,
                      size: 22,
                      customColor: titleColor,
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
