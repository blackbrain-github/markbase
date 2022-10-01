import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/note/note_screen.dart';
import 'package:flutter/material.dart';

class RecommendedNotesLogic {
  VariableNotifier<List<Note>> recentlyEditedNotes = VariableNotifier<List<Note>>([]);

  RecommendedNotesLogic();

  Future<void> loadRecentlyEditedNoteWidgets() async {
    List<Note> notes = await Database.get.recentlyEditedNotes();

    // Save to cache
    List<Map<String, dynamic>> notesAsMap = [];
    for (var i = 0; i < notes.length; i++) {
      notesAsMap.add(notes[i].toMap());
    }

    recentlyEditedNotes.set(notes);
  }

  Future<void> createNewNote(BuildContext context) async {
    try {
      Note newNote = await Database.create.note('/', null);
      List<Note> _notes = recentlyEditedNotes.get;
      _notes.add(newNote);
      recentlyEditedNotes.set(_notes, notify: true);
      Navigate(context).to(NoteScreen(newNote));
    } catch (e) {
      Show(context).errorMessage(message: e.toString());
    }
  }
}
