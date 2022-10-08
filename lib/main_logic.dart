import 'dart:io';

import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart';
import 'package:Markbase/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainLogic {
  static Future<void> confirmCurrentUser() async {
    Map<String, dynamic>? cachedUserModel = AppVariables.appState.read('user');

    if (cachedUserModel != null) {
      CommonLogic.appUser.set(UserModel.fromMap(cachedUserModel));
    }

    await FirebaseAuth.instance.currentUser?.reload();
    CommonLogic.isLoggedIn.set(FirebaseAuth.instance.currentUser != null, notify: true);

    // Get user details
    if (CommonLogic.isLoggedIn.get ?? false) {
      await CommonLogic.getAppUser(notify: true);
    }
  }

  static Future<void> checkMinimumRequiredVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isIOS) {
      String minimumRequiredVersion = FirebaseRemoteConfig.instance.getString('minimum_required_version_ios');
      String localVersion = packageInfo.version;

      // Used in settings screen
      CommonLogic.localVersion.set(localVersion, notify: false);
      String latestVersion = FirebaseRemoteConfig.instance.getString('latest_version_ios');
      CommonLogic.latestVersion.set(latestVersion, notify: false);

      if (int.parse(localVersion.replaceAll('.', '')) < int.parse(minimumRequiredVersion.replaceAll('.', ''))) {
        throw 'update-required';
      } else {
        return;
      }
    } else if (Platform.isAndroid) {
      String minimumRequiredVersion = FirebaseRemoteConfig.instance.getString('minimum_required_version_android');
      String localVersion = packageInfo.version;

      // Used in settings screen
      CommonLogic.localVersion.set(localVersion, notify: false);
      String latestVersion = FirebaseRemoteConfig.instance.getString('latest_version_android');
      CommonLogic.latestVersion.set(latestVersion, notify: false);

      if (int.parse(localVersion.replaceAll('.', '')) < int.parse(minimumRequiredVersion.replaceAll('.', ''))) {
        throw 'update-required';
      } else {
        return;
      }
    }
  }

  static void setTheme() {
    if (AppVariables.appState.read('theme') == 'system' || AppVariables.appState.read('theme') == null) {
      var systemBrightness = SchedulerBinding.instance.window.platformBrightness;
      if (systemBrightness == Brightness.dark) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        CommonLogic.theme.set(Theme.dark);
      } else if (systemBrightness == Brightness.light) {
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
