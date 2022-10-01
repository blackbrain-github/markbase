// Packages
import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/widgets/listen.dart';
import 'package:Markbase/ui_logic/database/database_screen.dart';
import 'package:Markbase/ui_logic/home/widgets/logo_and_settings_button.dart';
import 'package:Markbase/ui_logic/home/widgets/page_buttons.dart';
import 'package:Markbase/ui_logic/recommended_notes/recommended_notes_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String tab = 'home';
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listen(
      to: CommonLogic.theme,
      builder: (theme) => Scaffold(
        backgroundColor: AppColors.getPrimaryBackgroundColor(),
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
                    PageButtons(pageController),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  RecommendedNotesScreen(),
                  const DatabaseScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
