import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart' as Common;
import 'package:flutter/material.dart';

class CustomIndependentTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function? onChanged;
  final String? prefillText;
  final String? suffixText;
  final bool obscureText;
  final FocusNode? focusNode;
  final Common.Theme? theme;
  final TextInputType? textInputType;

  const CustomIndependentTextField({
    required this.title,
    required this.controller,
    this.onChanged,
    this.prefillText,
    this.suffixText,
    this.obscureText = false,
    this.focusNode,
    this.theme,
    this.textInputType,
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
        controller: controller,
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
        keyboardType: textInputType,
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
            borderSide: BorderSide(color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(0.2), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: AppColors.getInversePrimaryBackgroundColor(theme: theme).withOpacity(1), width: 0.5),
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
          fillColor: AppColors.getPrimaryBackgroundColor(theme: theme),
          filled: true,
        ),
        cursorColor: AppColors.getInversePrimaryBackgroundColor(theme: theme),
        cursorHeight: 20,
        cursorRadius: const Radius.circular(100),
      ),
    );
  }
}
