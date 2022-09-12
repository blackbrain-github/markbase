import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreenLogic {
  BuildContext context;
  late VariableNotifier<String> tab;
  late PageController pageController;

  VariableNotifier<List<NoteWidget>> recentlyEditedNoteWidgets;

  HomeScreenLogic(
    this.context, {
    required this.tab,
    required this.pageController,
    required this.recentlyEditedNoteWidgets,
  });

  void newBlankNote() async {
    showMaterialModalBottomSheet(
      context: context,
      duration: const Duration(milliseconds: 250),
      animationCurve: Curves.easeOutCirc,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.1),
      enableDrag: false,
      builder: (context) {
        return const SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Text("note screen woth eno"), /* NoteScreen(
              Note.blank(Provider.of<DatabaseExplorerProvider>(context, listen: false).currentCollection!),
            ),*/
          ),
        );
      },
    );
  }

  void loadCachedRecentlyEditedNoteWidgets() {
    var recentlyEditedNotes = AppVariables.appState.read('recently_edited_notes');
    if (recentlyEditedNotes != null) {
      List<NoteWidget> widgets = [];
      for (var i = 0; i < recentlyEditedNotes.length; i++) {
        widgets.add(NoteWidget(Note.fromMap(recentlyEditedNotes[i])));
      }
      recentlyEditedNoteWidgets.set(widgets, notify: false);
    }
    recentlyEditedNoteWidgets.set([], notify: false);
  }

  Future<void> loadRecentlyEditedNoteWidgets() async {
    List<Note> notes = await Database.get.recentlyEditedNotes();
    List<NoteWidget> noteWidgets = [];

    for (var i = 0; i < notes.length; i++) {
      noteWidgets.add(NoteWidget(notes[i]));
    }

    // Save to cache
    List<Map<String, dynamic>> notesAsMap = [];
    for (var i = 0; i < notes.length; i++) {
      notesAsMap.add(notes[i].toMap());
    }
    await AppVariables.appState.write('recently_edited_notes', notesAsMap);

    recentlyEditedNoteWidgets.set(noteWidgets);
  }
}
