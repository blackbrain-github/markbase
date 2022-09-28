import 'package:Markbase/dome/widgets/listen_bool.dart';
import 'package:Markbase/firebase_options.dart';
import 'package:Markbase/main_logic.dart';
import 'package:Markbase/ui_logic/auth_old/auth_screen.dart';
import 'package:Markbase/ui_logic/common/common_logic.dart' as App;
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:Markbase/update_required.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  FirebaseConstants.auth.currentUser?.reload();
  App.CommonLogic.isLoggedIn.set(FirebaseConstants.auth.currentUser != null, notify: false);

  await FirebaseConstants.remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  // Get user details
  try {
    if (App.CommonLogic.isLoggedIn.get ?? false) {
      await App.CommonLogic.getAppUser();
    }
  } catch (e) {
    // Do something
  }

  try {
    await FirebaseConstants.remoteConfig.fetchAndActivate();
  } catch (e) {
    // do something is configs are not able to be fetched?
  }

  try {
    await MainLogic.checkMinimumRequiredVersion();
    runApp(const Markbase());
  } catch (e) {
    runApp(const UpdateRequired());
  }

  MainLogic.setTheme();
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
}

class Markbase extends HookWidget {
  final bool updateRequired;
  const Markbase({this.updateRequired = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: updateRequired
          ? const UpdateRequired()
          : ListenBool(
              to: App.CommonLogic.isLoggedIn,
              ifTrue: const Master(),
              ifFalse: const AuthScreen(),
            ),
    );
  }
}
