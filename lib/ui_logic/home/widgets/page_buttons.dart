import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/content_spacer.dart';
import 'package:Markbase/ui_logic/home/home_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageButtons extends HookWidget {
  final HomeScreenLogic homeScreenLogic;
  const PageButtons(this.homeScreenLogic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: homeScreenLogic.tab,
      builder: (String tab) => Row(
        children: [
          ImportantButton(
            onPressed: () {
              if (homeScreenLogic.pageController.positions.isNotEmpty) {
                if (homeScreenLogic.pageController.page == 1.0) {
                  homeScreenLogic.pageController.jumpToPage(0);
                  homeScreenLogic.tab.set("home");
                }
              }
            },
            title: 'Home',
            selected: tab == 'home',
          ),
          const HorizontalSpacer(d: 5),
          ImportantButton(
            onPressed: () {
              if (homeScreenLogic.pageController.positions.isNotEmpty) {
                if (homeScreenLogic.pageController.page == 0.0) {
                  homeScreenLogic.pageController.jumpToPage(1);
                  homeScreenLogic.tab.set("database");
                }
              }
            },
            title: 'Database',
            selected: tab == 'database',
          ),
        ],
      ),
    );
  }
}
