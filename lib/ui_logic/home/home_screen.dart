// Packages
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/database/database_screen.dart';
import 'package:Markbase/ui_logic/home/home_screen_logic.dart';
import 'package:Markbase/ui_logic/home/widgets/floating_new_note_button.dart';
import 'package:Markbase/ui_logic/home/widgets/logo_and_settings_button.dart';
import 'package:Markbase/ui_logic/home/widgets/page_buttons.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenLogic logic = HomeScreenLogic(
      context,
      tab: VariableNotifier<String>("home"),
      pageController: usePageController(initialPage: 0),
    );

    return Listen(
      to: CommonLogic.theme,
      builder: (theme) => Scaffold(
        backgroundColor: AppColors.getPrimaryBackgroundColor(),
        floatingActionButton: FloatingNewNoteButton(logic),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, MediaQuery.of(context).viewInsets.top + 15, 15, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LogoAndSettingsButton(),
                    const SizedBox(height: 5),
                    PageButtons(logic),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Listen(
                to: logic.tab,
                builder: (String tab) {
                  if (logic.pageController.positions.isNotEmpty) {
                    tab == 'home' ? logic.pageController.jumpToPage(0) : logic.pageController.jumpToPage(1);
                  }
                  return PageView(
                    controller: logic.pageController,
                    onPageChanged: (int i) => logic.tab.set(i == 0 ? 'home' : 'database'),
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      RecommendedNotesScreen(),
                      DatabaseScreen(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}