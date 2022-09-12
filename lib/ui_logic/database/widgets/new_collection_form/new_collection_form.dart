import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:Markbase/ui_logic/database/widgets/new_collection_form/widgets/done_button.dart';
import 'package:Markbase/ui_logic/database/widgets/new_collection_form/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewCollectionPopup extends HookWidget {
  final DatabaseScreenLogic logic;
  const NewCollectionPopup(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, MediaQuery.of(context).viewInsets.bottom + 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              "New collection",
              size: 20,
              fontWeight: FontWeight.w700,
            ),
            const VerticalSpacer(),
            CollectionNameTextField(logic),
            const VerticalSpacer(),
            DoneButton(logic),
          ],
        ),
      ),
    );
  }
}
