import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/home/home_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FloatingNewNoteButton extends HookWidget {
  final HomeScreenLogic logic;
  const FloatingNewNoteButton(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: logic.tab,
      builder: (value) => value == "home"
          ? CustomAnimatedWidget(
              onPressed: () {
                logic.newBlankNote();
              },
              child: Container(
                height: 40,
                width: 53,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const CustomText(
                  "+",
                  fontWeight: FontWeight.w700,
                  size: 24,
                  customColor: Colors.white,
                ),
              ),
            )
          : Container(),
    );
  }
}
