import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/widgets/buttons/custom_button.dart';
import 'package:Markbase/dome/widgets/custom_independent_text_field.dart';
import 'package:Markbase/ui_logic/common_widgets/custom_text.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewCollectionPopup extends HookWidget {
  final DatabaseScreenLogic logic;
  NewCollectionPopup(this.logic, {Key? key}) : super(key: key);

  bool invalidCharacters = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = useTextEditingController();

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
        child: StatefulBuilder(builder: (context, setState) {
          controller.addListener(() {
            RegExp r = RegExp(r'^[a-zA-Z0-9 ]+$');
            if (!r.hasMatch(controller.text)) {
              setState(() {
                invalidCharacters = true;
              });
            } else {
              setState(() {
                invalidCharacters = false;
              });
            }
          });

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                "New collection",
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              CustomIndependentTextField(
                title: 'Name collection',
                controller: controller,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () async => logic.createNewCollection(context, controller.text),
                title: "Done",
                isAsync: true,
                disabled: invalidCharacters,
              ),
            ],
          );
        }),
      ),
    );
  }
}
