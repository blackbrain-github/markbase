import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FloatingNewNoteButton extends HookWidget {
  final RecommendedNotesLogic logic;
  const FloatingNewNoteButton(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      onPressed: () {
        logic.createNewNote(context);
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
    );
  }
}
