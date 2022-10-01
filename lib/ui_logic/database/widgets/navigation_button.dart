import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
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
        if (logic.currentCollection.get.path != '/') logic.loadPreviousCollection();
      },
      animate: logic.currentCollection.get.path != '/' ? true : false,
      child: Container(
        height: 40,
        width: 53,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: logic.currentCollection.get.path != '/' ? AppColors.accentColor : AppColors.getDisabledButtonColor(),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: logic.currentCollection.get.path != '/' ? AppColors.selectedButtonTextColor : AppColors.getDisabledButtonTextColor(),
          size: 18,
        ),
      ),
    );
  }
}
