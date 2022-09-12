import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:flutter/material.dart';

class ListenBool extends StatelessWidget {
  final VariableNotifier<bool?> to;
  final Widget ifFalse;
  final Widget? ifTrue;
  final bool animate;

  const ListenBool({
    required this.to,
    required this.ifFalse,
    this.ifTrue,
    this.animate = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: to,
      builder: (bool? value) {
        if (!(value ?? false)) {
          return ifFalse;
        }
        return ifTrue ?? const SizedBox();
      },
    );
  }
}
