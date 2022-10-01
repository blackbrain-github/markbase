import 'package:flutter/material.dart';

class ColumnWithSpacing extends StatelessWidget {
  final List<Widget> children;
  final double d;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;

  const ColumnWithSpacing({
    required this.children,
    this.d = 10,
    this.crossAxisAlignment,
    this.mainAxisSize,
  });

  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    int childIndex = -1;
    if (children.isEmpty) return Column(children: const []);
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: mainAxisSize ?? MainAxisSize.min,
      children: List.generate(
        (children.length * 2) - 1,
        (index) {
          if (index.isEven) {
            childIndex++;
            return children[childIndex];
          } else {
            return SizedBox(height: d);
          }
        },
      ),
    );
  }
}
