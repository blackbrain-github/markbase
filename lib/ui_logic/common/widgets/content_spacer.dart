import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double d;
  const VerticalSpacer({this.d = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: d,
    );
  }
}

class HorizontalSpacer extends StatelessWidget {
  final double d;
  const HorizontalSpacer({this.d = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: d,
    );
  }
}
