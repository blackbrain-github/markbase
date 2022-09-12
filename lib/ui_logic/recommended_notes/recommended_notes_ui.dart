import 'package:Markbase/ui_logic/home/home_screen_logic.dart';
import 'package:Markbase/ui_logic/home/widgets/recently_edited_notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendedNotes extends HookWidget {
  final HomeScreenLogic logic;
  const RecommendedNotes(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

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
