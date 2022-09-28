import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text_field.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.getPrimaryBackgroundColor(),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.getInversePrimaryBackgroundColor().withOpacity(0.2),
            width: 0.5,
          ),
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
            CustomTextField(
              title: 'Name collection',
              validator: () {},
              onSaved: () {},
              onChanged: (s) {
                print('thigs');
                logic.newCollectionTitle = s;
              },
            ),
            const VerticalSpacer(),
            ImportantButton(
              onPressed: () async => logic.createNewCollection(),
              title: "Done",
              isAsync: true,
            ),
          ],
        ),
      ),
    );
  }
}
