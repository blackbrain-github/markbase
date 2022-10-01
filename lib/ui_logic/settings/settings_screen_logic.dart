import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/ui_logic/auth/start/start_auth_screen.dart';
import 'package:Markbase/ui_logic/settings/setting_screens/account_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
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
    await FirebaseAuth.instance.signOut();
    await AppVariables.appState.erase();
    await FirebaseAuth.instance.currentUser?.reload();
    CommonLogic.isLoggedIn.set(false, notify: false);

    // Reset theme
    var systemBrightness = SchedulerBinding.instance.window.platformBrightness;
    if (systemBrightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      CommonLogic.theme.set(Theme.dark);
    } else if (systemBrightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      CommonLogic.theme.set(Theme.light);
    }

    Navigate(context).to(const StartAuthScreen(), ableToGoBack: false);
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

  void rateUs() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  void suggestANewFeature() async {
    Uri uri = Uri.parse('https://forms.gle/UHcPk7nVPNsjZJr67');
    if (await launchUrl(uri)) {
      // Something went wrong
    }
  }
}
