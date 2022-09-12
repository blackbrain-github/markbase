import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavigationButton extends HookWidget {
  final DatabaseScreenLogic logic;
  const NavigationButton(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      onPressed: () {
        if (logic.history.isNotEmpty) logic.goBack();
      },
      animate: logic.history.isNotEmpty ? true : false,
      child: Container(
        height: 40,
        width: 53,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: logic.history.isNotEmpty ? AppColors.accentColor : AppColors.getDisabledButtonColor(),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: logic.history.isNotEmpty ? AppColors.selectedButtonTextColor : AppColors.getDisabledButtonTextColor(),
          size: 18,
        ),
      ),
    );
  }
}
