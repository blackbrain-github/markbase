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

  const CustomTextField({
    required this.title,
    required this.validator,
    required this.onSaved,
    this.onChanged,
    this.prefillText,
    this.suffixText,
    this.obscureText = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      initialValue: (prefillText == null) ? null : prefillText,
      obscureText: obscureText,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: title,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        suffixText: (suffixText == null) ? null : suffixText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(style: BorderStyle.none),
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
        fillColor: const Color(0xFFF3F3F4),
        filled: true,
      ),
      cursorColor: Colors.black,
      cursorHeight: 20,
      cursorRadius: const Radius.circular(100),
    );
  }
}
