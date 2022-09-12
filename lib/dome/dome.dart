import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExampleScreenLogic {
  final VariableNotifier<String?> text;

  ExampleScreenLogic({
    required this.text,
  });
}

class ExampleScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    ExampleScreenLogic logic = ExampleScreenLogic(
      text: VariableNotifier<String>("Initial"),
    );

    useEffect(() {
      // Init
      return null;
    });

    return Scaffold(
      body: Column(children: [
        TextButton(
          onPressed: () => logic.text.set("Updated"),
          child: const Text("Change text"),
        ),
        Listen(
            to: logic.text,
            builder: (String? text) {
              return Text(text ?? "No value");
            }),
      ]),
    );
  }
}
