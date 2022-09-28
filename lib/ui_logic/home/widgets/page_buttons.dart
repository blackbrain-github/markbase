import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/home/home_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageButtons extends HookWidget {
  final HomeScreenLogic logic;
  const PageButtons(this.logic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: logic.tab,
      builder: (String tab) {
        print("Tab: " + tab);
        return Row(
          children: [
            ImportantButton(
              onPressed: () {
                if (logic.pageController.positions.isNotEmpty) {
                  if (logic.pageController.page == 1.0) {
                    logic.pageController.jumpToPage(0);
                    logic.tab.set("home");
                  }
                }
              },
              title: 'Home',
              selected: tab == 'home',
              maxRoundedCorners: true,
            ),
            const HorizontalSpacer(d: 5),
            ImportantButton(
              onPressed: () {
                if (logic.pageController.positions.isNotEmpty) {
                  if (logic.pageController.page == 0.0) {
                    logic.pageController.jumpToPage(1);
                    logic.tab.set("database");
                  }
                }
              },
              title: 'Database',
              selected: tab == 'database',
              maxRoundedCorners: true,
            ),
          ],
        );
      },
    );
  }
}
