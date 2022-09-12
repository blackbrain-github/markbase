// ---------------------------- IMPORTS ---------------------------- //

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final Function onChanged;

  CustomSwitch({required this.value, required this.onChanged});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
// -------------------------- VARIABLES ---------------------------- //

// -------------------------- FUNCTIONS ---------------------------- //

// ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: widget.value,
      duration: Duration(milliseconds: 100),
      activeColor: Theme.of(context).colorScheme.secondary,
      inactiveColor: Color(0xFF212121),
      height: 22,
      width: 44,
      toggleSize: 16,
      onToggle: (val) => widget.onChanged(val),
    );
  }
}
