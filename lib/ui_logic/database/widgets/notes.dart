import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/loading.dart';
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
                    logic.currentCollection.get.parentPath ?? '',
                    logic.currentCollection.get.id ?? '',
                  );
                  List<Note> notes = logic.currentCollectionNotes.get;
                  notes.add(newNote);
                  logic.currentCollectionNotes.set(notes);
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
        Listen(
          to: logic.currentCollectionNotes,
          builder: (List<Note> notes) {
            return Listen(
              to: logic.notesLoading,
              builder: (bool loading) {
                return loading
                    ? const MarkbaseLoadingWidget()
                    : logic.currentCollectionNotes.get.isNotEmpty
                        ? ColumnWithSpacing(
                            d: 5,
                            children: List.generate(
                              notes.length,
                              (index) => NoteWidget(notes.elementAt(index)),
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
                          );
              },
            );
          },
        ),
      ],
    );
  }
}
