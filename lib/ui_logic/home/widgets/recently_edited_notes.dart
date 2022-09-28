import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/loading.dart';
import 'package:Markbase/ui_logic/common/widgets/note_widget.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecentlyEditedNotes extends HookWidget {
  final RecommendedNotesLogic logic;
  const RecentlyEditedNotes(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          "Pick up where you left off:",
          size: 16,
          fontWeight: FontWeight.w600,
          color: TextColorType.secondary,
        ),
        const VerticalSpacer(d: 10),
        FutureBuilder(
          future: logic.loadRecentlyEditedNoteWidgets(),
          builder: (context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Listen(
                to: logic.recentlyEditedNoteWidgets,
                builder: (List<NoteWidget> widgets) {
                  return ColumnWithSpacing(d: 7, children: widgets);
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              logic.loadCachedRecentlyEditedNoteWidgets();
              if (logic.recentlyEditedNoteWidgets.get.isNotEmpty) {
                return ColumnWithSpacing(
                  d: 7,
                  children: logic.recentlyEditedNoteWidgets.get,
                );
              } else {
                return const Center(
                  child: MarkbaseLoadingWidget(),
                );
              }
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No notes'));
            } else {
              return const Text('Something went wrong');
            }
          },
        ),
      ],
    );
  }
}
