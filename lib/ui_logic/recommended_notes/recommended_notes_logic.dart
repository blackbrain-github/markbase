import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/note_widget.dart';

class RecommendedNotesLogic {
  VariableNotifier<List<NoteWidget>> recentlyEditedNoteWidgets;

  RecommendedNotesLogic({
    required this.recentlyEditedNoteWidgets,
  });

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
