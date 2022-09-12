import 'package:Markbase/ui_logic/database/database_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CollectionNameTextField extends HookWidget {
  final DatabaseScreenLogic logic;
  const CollectionNameTextField(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (name) => logic.newCollectionTitle = name,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.only(
          bottom: 12,
          left: 12,
          right: 12,
        ),
        fillColor: Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(
            0.25,
          ),
          fontFamily: "Medium",
        ),
        hintText: "Name your collection",
        errorText: "Error",
      ),
      minLines: 1,
      maxLines: 1,
    );
  }
}
