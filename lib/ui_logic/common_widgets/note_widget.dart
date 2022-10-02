import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/widgets/custom_animated_widget.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/app_vibrate.dart';
import 'package:Markbase/ui_logic/note/note_screen.dart';
import 'package:flutter/material.dart';

class NoteWidget extends StatefulWidget {
  Note note;
  final Function? removeWidgetFromList;
  NoteWidget(this.note, {this.removeWidgetFromList, Key? key}) : super(key: key);

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    String title = "";
    List<String> bodySplit = [];
    String body = "";

    if (widget.note.body.isNotEmpty) {
      title = widget.note.body.split('\n').first;
      bodySplit = widget.note.body.split('\n');
      bodySplit.remove(title);

      // Removes space between title and body
      if (bodySplit.isNotEmpty) {
        if (bodySplit.length != 1 && bodySplit[0] == '') bodySplit.removeAt(0);
      }

      body = bodySplit.join('\n');
    }

    return Listen(
      to: CommonLogic.theme,
      builder: (_) => CustomAnimatedWidget(
        onPressed: () async {
          // NoteScreen returns updated note
          var result = await Navigate(context).to(NoteScreen(widget.note));
          if (result is Note) {
            setState(() {
              widget.note = result;
            });
          } else {
            Show(context).errorMessage(message: 'Error saving note');
          }
        },
        onLongPress: () async {
          AppVibrate.impact();
          var r = await Show(context).deleteNote(widget.note);
          if (widget.removeWidgetFromList != null) {
            if (r is Note) {
              widget.removeWidgetFromList!();
            }
          }
        },
        endSize: 0.99,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.getNoteColor(),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 0.5,
                color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.05),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: AppColors.getShadowColor(),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomText(
                  title != "" ? title : "Untitled note",
                  size: 16,
                  fontWeight: FontWeight.w700,
                  softWrap: true,
                  color: TextColorType.primary,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),
                if (body != "")
                  CustomText(
                    body,
                    fontWeight: FontWeight.w500,
                    size: 14,
                    color: TextColorType.secondary,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    maxLines: 5,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
