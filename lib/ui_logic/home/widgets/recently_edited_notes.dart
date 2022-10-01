import 'package:Markbase/dome/widgets/column_with_spacing.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common_widgets/note_widget.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_logic.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecentlyEditedNotes extends StatefulWidget {
  final RecommendedNotesLogic logic;
  const RecentlyEditedNotes(this.logic, {Key? key}) : super(key: key);

  @override
  State<RecentlyEditedNotes> createState() => _RecentlyEditedNotesState();
}

class _RecentlyEditedNotesState extends State<RecentlyEditedNotes> {
  @override
  void initState() {
    super.initState();
    widget.logic.loadRecentlyEditedNoteWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: widget.logic.recentlyEditedNotes,
      builder: (List<Note> notes) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (notes.isNotEmpty) {
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
                  const SizedBox(height: 10),
                  ColumnWithSpacing(
                    d: 7,
                    children: List.generate(
                      notes.length,
                      (index) => NoteWidget(
                        notes.elementAt(index),
                        removeWidgetFromList: () {
                          setState(() {
                            notes.remove(notes.elementAt(index));
                          });
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    "Pick up where you left off:",
                    size: 16,
                    fontWeight: FontWeight.w600,
                    color: TextColorType.secondary,
                  ),
                  const SizedBox(height: 10),
                  Center(child: Lottie.asset('assets/lottie/empty.json', width: MediaQuery.of(context).size.width * 0.7)),
                  const SizedBox(height: 15),
                  const Center(child: CustomText("It's so empty here...", color: TextColorType.secondary, fontWeight: FontWeight.w600)),
                ],
              );
            }
          },
        );
      },
    );
  }
}
