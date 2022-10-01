// Packages
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Master extends HookWidget {
  const Master({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.theme,
      builder: (value) => const HomeScreen(),
    );
  }
}
