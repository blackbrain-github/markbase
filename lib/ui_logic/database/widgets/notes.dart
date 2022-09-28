import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/note_widget.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/note/note_screen.dart';
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
              onPressed: () async {
                try {
                  Note newNote = await Database.create.note(
                    logic.currentCollection.get.path,
                    logic.currentCollection.get.id ?? '',
                  );
                  List<Note> notes = logic.currentCollection.get.notes ?? [];
                  notes.add(newNote);
                  logic.currentCollection.set(logic.currentCollection.get..notes = notes);
                  var r = await Navigate(context).to(NoteScreen(newNote));
                } catch (e) {
                  Show(context).errorMessage(message: e.toString());
                }
              },
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
        (logic.currentCollection.get.collections?.isNotEmpty ?? false)
            ? ColumnWithSpacing(
                d: 7,
                children: List.generate(
                  logic.currentCollection.get.notes?.length ?? 0,
                  (index) => NoteWidget(logic.currentCollection.get.notes!.elementAt(index)),
                ),
              )
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
              ),
      ],
    );
  }
}
