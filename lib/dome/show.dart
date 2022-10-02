import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_popup.dart';
import 'package:Markbase/dome/widgets/custom_text.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_logic.dart';
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
  Future<dynamic> bottomSheet(Widget child, {bool useBase = true}) {
    return showModalBottomSheet(
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

  Future<dynamic> deleteNote(Note note) {
    return bottomSheet(
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
              CustomButton(
                onPressed: () async {
                  await Database.delete.note(note);
                  Navigator.of(context).maybePop(note);
                },
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

  Future<dynamic> deleteCollection(Collection collection) {
    return bottomSheet(
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
                "Delete collection",
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () async {
                  await Database.delete.collection(collection);
                  Navigator.of(context).maybePop(collection);
                },
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

  Future<String?> welcomeToMarkbase(RecommendedNotesLogic logic) async {
    return await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.getPrimaryBackgroundColor(),
                border: Border.all(
                  width: 0.5,
                  color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CustomText(
                    'Welcome to Markbase',
                    size: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 5),
                  const CustomText(
                    'We appreciate you for downloading the app and truly hope you enjoy it.\n\nThere are many features that you can go explore but how about we get you started with a simple first note?',
                    color: TextColorType.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).maybePop('create-note');
                          },
                          title: 'Sure',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          title: 'No thanks',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
