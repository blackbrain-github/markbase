import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Show {
  final BuildContext context;
  Show(this.context);

  void _showInfoPopup(BuildContext context, String title, {String? description}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return CustomPopup(
          title: title,
          description: description ?? "",
          buttonTitle: "Ok",
          buttonFunction: () => Navigator.of(context).maybePop(),
        );
      },
    );
  }

  /// Show bottom sheet with content. By default, given 'child' will be
  /// placed inside a base which is Scaffold -> SafeArea -> Padding(15). Set useBase
  /// to false to have a child with to parent.
  void bottomSheet(Widget child, {bool useBase = true}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.3),
      isDismissible: true,
      builder: (context) {
        return useBase
            ? Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: child,
                  ),
                ),
              )
            : child;
      },
    );
  }

  /// Show a popup with an error message and an 'Ok' button
  void errorMessage({String message = "Something went wrong"}) {
    _showInfoPopup(
      context,
      message,
    );
  }

  /// Show a popup with 'Are you sure?', detail text and 'Yes' and 'Go back' buttons
  void areYouSure(String details, {Function? continueFunction}) {
    /// show popup with Column(Text, Text, Row(Button, Button))
    /// 'Yes' button will trigger continue function
    /// 'Go back' button will trigget Navigator.pop()
  }

  void deleteNote(Note note) {
    bottomSheet(
      SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, MediaQuery.of(context).viewInsets.bottom + 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.getPrimaryBackgroundColor(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 0.5,
              color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: AppColors.getShadowColor(),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                "Delete note",
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              ImportantButton(
                onPressed: () async {
                  await Database.delete.note(note);
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).maybePop();
                },
                big: true,
                title: "Delete",
                isAsync: true,
              ),
            ],
          ),
        ),
      ),
      useBase: false,
    );
  }
}
