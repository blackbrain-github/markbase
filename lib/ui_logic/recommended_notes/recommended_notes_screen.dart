import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/ui_logic/common/widgets/note_widget.dart';
import 'package:Markbase/ui_logic/home/widgets/recently_edited_notes.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendedNotesScreen extends HookWidget {
  const RecommendedNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    RecommendedNotesLogic logic = RecommendedNotesLogic(
      recentlyEditedNoteWidgets: VariableNotifier<List<NoteWidget>>([]),
    );

    print("updated recommendedNotes");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: () => logic.loadRecentlyEditedNoteWidgets(),
        child: ListView(
          shrinkWrap: false,
          padding: EdgeInsets.zero,
          children: [
            RecentlyEditedNotes(logic),
          ],
        ),
      ),
    );
  }
}
