import 'package:Markbase/models/note.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NoteBottomBar extends HookWidget {
  final Note note;
  final TextEditingController bodyController;
  const NoteBottomBar(this.note, this.bodyController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      color: AppColors.getNoteColor(),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.getNoteColor(),
          boxShadow: [
            BoxShadow(
              color: AppColors.getShadowColor(),
              blurRadius: 20,
              offset: const Offset(0, -20),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: AppColors.getPrimaryBackgroundColor().withOpacity(0.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                children: [
                  CustomAnimatedWidget(
                    onPressed: () async {
                      // Updated note is returned
                      Navigator.maybePop(context, note);
                    },
                    child: Container(
                      height: 40,
                      width: 53,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.selectedButtonTextColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.getPrimaryBackgroundColor(),
                      ),
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              note.inCollectionPath.replaceAll(note.title, "") + '/',
                              color: TextColorType.secondary,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) {
                                bodyController.addListener(() => setState(() {}));
                                return CustomText(
                                  note.title,
                                  color: TextColorType.primary,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
