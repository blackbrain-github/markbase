import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/ui_logic/auth/auth_screen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:Markbase/ui_logic/settings/setting_screens/account_details_screen.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/services.dart';

class SettingsScreenLogic {
  String theme = AppVariables.appState.read('theme') ?? 'light';

  // Look
  void changeTheme(String theme) async {
    if (theme == 'Light') {
      await AppVariables.appState.write('theme', 'light');
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      CommonLogic.theme.set(Theme.light);
    } else if (theme == 'Dark') {
      await AppVariables.appState.write('theme', 'dark');
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      CommonLogic.theme.set(Theme.dark);
    }
  }

  void changeDatabaseLook(String databaseLook) {}

  void changeInitialView(String initialView) {}

  // Account
  void seeAccountDetails(Material.BuildContext context) {
    Navigate(context).to(const AccountDetailsScreen());
  }

  void switchAccount() {}

  void logOut(Material.BuildContext context) async {
    await FirebaseConstants.auth.signOut();
    await AppVariables.appState.erase();
    await FirebaseConstants.auth.currentUser?.reload();
    CommonLogic.isLoggedIn.set(false, notify: false);

    Navigate(context).to(const AuthScreen(), ableToGoBack: false);
  }

  // Need help with something?
  void contactSupport() {}

  // Help make Markbase better
  void giveFeedback() {}

  void rateUs() {}

  void suggestANewFeature() {}
}
