import 'package:flutter/material.dart';

class NoteTextEditingController extends TextEditingController {
  NoteTextEditingController() : super();

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, bool? withComposing}) {
    final List<InlineSpan> children = [];

    TextStyle titleStyle = const TextStyle(
      fontFamily: 'SemiBold',
      fontSize: 20,
    );

    // Take title
    List<String> split = text.split('\n');
    children.add(
      TextSpan(
        text: split.first + '\n',
        style: style?.merge(titleStyle),
      ),
    );

    split.removeAt(0);

    for (var i = 0; i < split.length; i++) {
      children.add(TextSpan(text: split[i] + '\n', style: style));
    }

    return TextSpan(style: style, children: children);
  }
}
