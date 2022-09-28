// Packages

import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/note/note_bottom_bar.dart';
import 'package:Markbase/ui_logic/note/note_text_editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NoteScreen extends StatefulWidget {
  Note note;
  NoteScreen(this.note, {Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late NoteTextEditingController noteTextEditingController;
  late TextEditingController bottomBarSearchController;
  late PanelController panelController;

  FocusNode bodyNode = FocusNode();

  @override
  void initState() {
    super.initState();
    noteTextEditingController = NoteTextEditingController()
      ..text = widget.note.body
      ..addListener(() {
        widget.note.body = noteTextEditingController.text.trim();
      });
  }

  @override
  void dispose() {
    noteTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Save to database when popped
        Database.modify.note(widget.note);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.getPrimaryBackgroundColor(),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        const SliverToBoxAdapter(
                          child: VerticalSpacer(d: 15),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextField(
                              controller: noteTextEditingController,
                              focusNode: bodyNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Type something',
                                hintStyle: TextStyle(
                                  color: AppColors.getSecondaryTextColor(),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 50,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getPrimaryTextColor(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NoteBottomBar(widget.note, noteTextEditingController),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
