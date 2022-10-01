import 'package:Markbase/dome/widgets/column_with_spacing.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common_widgets/note_widget.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Notes extends HookWidget {
  final DatabaseScreenLogic logic;
  const Notes(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText("Notes:", size: 16, fontWeight: FontWeight.w600, color: TextColorType.secondary),
            CustomAnimatedWidget(
              onPressed: () async => logic.createNewNote(context),
              child: const CustomText(
                "New note",
                size: 16,
                fontWeight: FontWeight.w600,
                color: TextColorType.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Listen(
          to: logic.notes,
          builder: (List<Note> notes) {
            return notes.isNotEmpty
                ? StatefulBuilder(builder: (context, setState) {
                    return ColumnWithSpacing(
                      d: 7,
                      children: List.generate(
                        notes.length,
                        (index) => NoteWidget(
                          notes.elementAt(index),
                          removeWidgetFromList: () {
                            setState(() {
                              notes.remove(notes.elementAt(index));
                            });
                          },
                        ),
                      ),
                    );
                  })
                : const SizedBox(
                    height: 30,
                    child: Center(
                      child: CustomText(
                        "No notes",
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: TextColorType.secondary,
                      ),
                    ),
                  );
          },
        )
      ],
    );
  }
}
