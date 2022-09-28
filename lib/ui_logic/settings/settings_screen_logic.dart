import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/ui_logic/auth_old/auth_screen.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:Markbase/ui_logic/settings/setting_screens/account_details_screen.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
    } else if (theme == 'System') {
      await AppVariables.appState.write('theme', 'system');

      var systemBrightness = SchedulerBinding.instance.window.platformBrightness;
      if (systemBrightness == Material.Brightness.light) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        CommonLogic.theme.set(Theme.light);
      } else if (systemBrightness == Material.Brightness.dark) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        CommonLogic.theme.set(Theme.dark);
      }
    }
  }

  // Account
  void seeAccountDetails(Material.BuildContext context) {
    Navigate(context).to(AccountDetailsScreen(this));
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
  void contactSupport() async {
    Uri uri = Uri.parse('mailto:support@markba.se');
    if (await launchUrl(uri)) {
      // Something went wrong
    }
  }

  // Help make Markbase better
  void giveFeedback() async {
    Uri uri = Uri.parse('https://forms.gle/YASSG5UmXz3P2EHK7');
    if (await launchUrl(uri)) {
      // Something went wrong
    }
  }

  void rateUs() {
    AppReview.requestReview.then((onValue) {
      print(onValue);
    });
  }

  void suggestANewFeature() async {
    Uri uri = Uri.parse('https://forms.gle/UHcPk7nVPNsjZJr67');
    if (await launchUrl(uri)) {
      // Something went wrong
    }
  }
}
