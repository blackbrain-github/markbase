// \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\
/*
      ___           ___           ___           ___                         ___           ___           ___     
     /__/\         /  /\         /  /\         /__/|         _____         /  /\         /  /\         /  /\    
    |  |::\       /  /::\       /  /::\       |  |:|        /  /::\       /  /::\       /  /:/_       /  /:/_   
    |  |:|:\     /  /:/\:\     /  /:/\:\      |  |:|       /  /:/\:\     /  /:/\:\     /  /:/ /\     /  /:/ /\  
  __|__|:|\:\   /  /:/~/::\   /  /:/~/:/    __|  |:|      /  /:/~/::\   /  /:/~/::\   /  /:/ /::\   /  /:/ /:/_ 
 /__/::::| \:\ /__/:/ /:/\:\ /__/:/ /:/___ /__/\_|:|____ /__/:/ /:/\:| /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/ /:/ /\
 \  \:\~~\__\/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\/:::::/ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:/~/:/ \  \:\/:/ /:/
  \  \:\        \  \::/       \  \::/~~~~   \  \::/~~~~   \  \::/ /:/   \  \::/       \  \::/ /:/   \  \::/ /:/ 
   \  \:\        \  \:\        \  \:\        \  \:\        \  \:\/:/     \  \:\        \__\/ /:/     \  \:\/:/  
    \  \:\        \  \:\        \  \:\        \  \:\        \  \::/       \  \:\         /__/:/       \  \::/   
     \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/    

     Created 10/22
     By Juuso Käyhkö aliased as Blackbrain

     Visit nerd.blackbra.in/markbase for a surprise
*/
// \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\

import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/app_specific/common_logic.dart' as App;
import 'package:Markbase/dome/widgets/listen_bool.dart';
import 'package:Markbase/firebase_options.dart';
import 'package:Markbase/main_logic.dart';
import 'package:Markbase/ui_logic/auth/start/start_auth_screen.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:Markbase/update_required.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate();

  // Initialize Firebase Remote Config
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  MainLogic.confirmCurrentUser();

  // Set correct theme
  MainLogic.setTheme();

  runApp(const Markbase());
}

class Markbase extends StatefulWidget {
  const Markbase({Key? key}) : super(key: key);

  @override
  State<Markbase> createState() => _MarkbaseState();
}

class _MarkbaseState extends State<Markbase> {
  bool updateRequired = false;

  void checkIfAppNeedsToBeUpdated() async {
    try {
      await FirebaseRemoteConfig.instance.fetchAndActivate();
      await MainLogic.checkMinimumRequiredVersion();
    } catch (e) {
      if (e == 'update-required') {
        setState(() {
          updateRequired = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfAppNeedsToBeUpdated();
  }

  @override
  Widget build(BuildContext context) {
    // Only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          // Used to change scroll glow effect on Android
          accentColor: AppColors.accentColor,
        ),
      ),
      home: updateRequired
          ? const UpdateRequired()
          : ListenBool(
              to: App.CommonLogic.isLoggedIn,
              ifTrue: const Master(),
              ifFalse: const StartAuthScreen(),
            ),
    );
  }
}
