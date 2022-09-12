import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DoneButton extends HookWidget {
  final DatabaseScreenLogic logic;
  const DoneButton(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImportantButton(
      onPressed: () async => logic.createNewCollection(),
      title: "Done",
      isAsync: true,
      /*function: () async {
        String newCollectionName = newCollectionController.text;

        if (newCollectionName == "") {
          setState(() {
            errorText = "Collection name cannot be empty";
          });
        } else if (newCollectionName.contains("-")) {
          setState(() {
            errorText = "Collection name cannot contain '-' symbol";
          });
        } else {
          setState(() {
            errorText = null;
          });

          //String currentPath = databaseProvider(context).currentPath;
          String newCollectionPathName = newCollectionName.toLowerCase().replaceAll(" ", "-");

          try {
            //Collection newCollection = await Database.create.collection(
            //  "${(currentPath != "/" ? currentPath : "")}/$newCollectionPathName",
            //  newCollectionName,
            //);
            //databaseProvider(context).newCollection(newCollection);

            Navigator.of(context).maybePop();
          } catch (e) {
            throw "Error creating new collection [in AddNewCollection widget]";
          }
        }
      },*/
    );
  }
}
