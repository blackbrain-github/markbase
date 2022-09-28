import 'dart:io';

import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainLogic {
  static Future<void> checkMinimumRequiredVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isIOS) {
      String minimumRequiredVersion = FirebaseConstants.remoteConfig.getString('minimum_required_version_ios');
      String localVersion = packageInfo.version;

      // Used in settings screen
      CommonLogic.localVersion.set(localVersion, notify: false);
      String latestVersion = FirebaseConstants.remoteConfig.getString('latest_version_ios');
      CommonLogic.latestVersion.set(latestVersion, notify: false);

      if (int.parse(localVersion.replaceAll('.', '')) < int.parse(minimumRequiredVersion.replaceAll('.', ''))) {
        throw 'update required';
        // runApp(const Markbase(updateRequired: false));
      } else {
        return;
        // runApp(const Markbase());
      }
    } else if (Platform.isAndroid) {
      String minimumRequiredVersion = FirebaseConstants.remoteConfig.getString('minimum_required_version_android');
      String localVersion = packageInfo.version;

      // Used in settings screen
      CommonLogic.localVersion.set(localVersion, notify: false);
      String latestVersion = FirebaseConstants.remoteConfig.getString('latest_version_android');
      CommonLogic.latestVersion.set(latestVersion, notify: false);

      if (int.parse(localVersion.replaceAll('.', '')) < int.parse(minimumRequiredVersion.replaceAll('.', ''))) {
        throw 'update required';
        // runApp(const Markbase(updateRequired: true));
      } else {
        return;
        // runApp(const Markbase());
      }
    }
  }

  static void setTheme() {
    if (AppVariables.appState.read('theme') == 'system' || AppVariables.appState.read('theme') == null) {
      var systemBrightness = SchedulerBinding.instance.window.platformBrightness;
      if (systemBrightness == Brightness.dark) {
        print('System is in dark mode');
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        CommonLogic.theme.set(Theme.dark);
      } else if (systemBrightness == Brightness.light) {
        print('System is in light mode');
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        CommonLogic.theme.set(Theme.light);
      }
    } else if (AppVariables.appState.read('theme') == 'light') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      CommonLogic.theme.set(Theme.light);
    } else if (AppVariables.appState.read('theme') == 'dark') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      CommonLogic.theme.set(Theme.dark);
    }
  }
}
