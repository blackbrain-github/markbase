import 'package:Markbase/dome/show.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/home/widgets/floating_new_note_button.dart';
import 'package:Markbase/ui_logic/home/widgets/recently_edited_notes.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_logic.dart';
import 'package:flutter/material.dart';

class RecommendedNotesScreen extends StatefulWidget {
  const RecommendedNotesScreen({Key? key}) : super(key: key);

  @override
  State<RecommendedNotesScreen> createState() => _RecommendedNotesScreenState();
}

class _RecommendedNotesScreenState extends State<RecommendedNotesScreen> with AutomaticKeepAliveClientMixin {
  RecommendedNotesLogic logic = RecommendedNotesLogic();

  @override
  void initState() {
    super.initState();

    Database.get.recentlyEditedNotes().then((notes) {
      if (notes.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          var r = await Show(context).welcomeToMarkbase(logic);
          if (r == 'create-note') {
            logic.createNewNote(context);
          }
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingNewNoteButton(logic),
      backgroundColor: Colors.transparent,
      body: Padding(
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
      ),
    );
  }
}
