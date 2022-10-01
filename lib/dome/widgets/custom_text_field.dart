import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart' as Common;
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final Function validator;
  final Function onSaved;
  final Function? onChanged;
  final String? prefillText;
  final String? suffixText;
  final bool obscureText;
  final FocusNode? focusNode;
  final Common.Theme? theme;

  const CustomTextField({
    required this.title,
    required this.validator,
    required this.onSaved,
    this.onChanged,
    this.prefillText,
    this.suffixText,
    this.obscureText = false,
    this.focusNode,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: AppColors.getShadowColor(theme: theme),
          )
        ],
      ),
      child: TextFormField(
        validator: (s) {
          return validator(s);
        },
        onSaved: (s) {
          onSaved(s);
        },
        onChanged: (s) {
          if (onChanged != null) {
            onChanged!(s);
          }
        },
        style: TextStyle(
          fontSize: 16,
          color: AppColors.getPrimaryTextColor(theme: theme),
        ),
        initialValue: (prefillText == null) ? null : prefillText,
        obscureText: obscureText,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            bottom: 12,
            left: 12,
            right: 12,
          ),
          hintText: title,
          hintStyle: TextStyle(
            fontSize: 16,
            color: AppColors.getSecondaryTextColor(theme: theme),
          ),
          suffixText: (suffixText == null) ? null : suffixText,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.1), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.1), width: 0.5),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(style: BorderStyle.none),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(style: BorderStyle.none),
          ),
          fillColor: AppColors.getNoteColor(theme: theme),
          filled: true,
        ),
        cursorColor: AppColors.getInversePrimaryBackgroundColor(theme: theme),
        cursorHeight: 20,
        cursorRadius: const Radius.circular(100),
      ),
    );
  }
}
