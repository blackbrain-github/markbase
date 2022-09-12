import 'dart:io';

import 'package:Markbase/dome/widgets/listen_bool.dart';
import 'package:Markbase/firebase_options.dart';
import 'package:Markbase/ui_logic/auth/auth_screen.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart';
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  FirebaseConstants.auth.currentUser?.reload();
  CommonLogic.isLoggedIn.set(FirebaseConstants.auth.currentUser != null, notify: false);

  await FirebaseConstants.remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  await FirebaseConstants.remoteConfig.fetchAndActivate();
  if (Platform.isIOS) {
    String minimumRequiredVersion = FirebaseConstants.remoteConfig.getString('minimum_required_version_ios');
    String currentVersion = packageInfo.version;

    if (int.parse(currentVersion.replaceAll('.', '')) < int.parse(minimumRequiredVersion.replaceAll('.', ''))) {
      runApp(Container());
    }
  } else if (Platform.isAndroid) {
    String minimumRequiredVersion = FirebaseConstants.remoteConfig.getString('minimum_required_version_android');
    String currentVersion = packageInfo.version;

    if (int.parse(currentVersion.replaceAll('.', '')) < int.parse(minimumRequiredVersion.replaceAll('.', ''))) {
      runApp(Container());
    }
  }

  runApp(const Markbase());
}

class Markbase extends HookWidget {
  const Markbase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: ListenBool(
        to: CommonLogic.isLoggedIn,
        ifTrue: const Master(),
        ifFalse: const AuthScreen(),
      ),
    );
  }
}
