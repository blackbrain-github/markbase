import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/note/note_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenLogic {
  BuildContext context;
  late VariableNotifier<String> tab;
  late PageController pageController;

  HomeScreenLogic(
    this.context, {
    required this.tab,
    required this.pageController,
  });

  void newBlankNote() async {
    try {
      Note newNote = await Database.create.note('', '');
      var r = await Navigate(context).to(NoteScreen(newNote));
    } catch (e) {
      Show(context).errorMessage(message: e.toString());
    }
  }
}
