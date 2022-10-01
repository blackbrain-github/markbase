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

import 'package:Markbase/dome/app_specific/common_logic.dart' as App;
import 'package:Markbase/dome/widgets/listen_bool.dart';
import 'package:Markbase/firebase_options.dart';
import 'package:Markbase/main_logic.dart';
import 'package:Markbase/ui_logic/auth/start/start_auth_screen.dart';
import 'package:Markbase/ui_logic/master.dart';
import 'package:Markbase/update_required.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // \\ // \\ // \\ // \\ // \\ FIREBASE // \\ // \\ // \\ // \\ // \\

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

  try {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
  } catch (e) {
    // do something is configs are not able to be fetched?
  }

  // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\

  // \\ // \\ // \\ // \\ // \\ AUTH // \\ // \\ // \\ // \\ // \\

  // Ensures app has correct auth state
  await FirebaseAuth.instance.currentUser?.reload();

  // Updates isLoggedIn state in app
  App.CommonLogic.isLoggedIn.set(FirebaseAuth.instance.currentUser != null, notify: false);

  // Get user details
  if (App.CommonLogic.isLoggedIn.get ?? false) {
    await App.CommonLogic.getAppUser();
  }

  // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\

  // Initialize GetStorage
  await GetStorage.init();

  // Set correct theme
  MainLogic.setTheme();

  // Check if app requires update and run
  try {
    await MainLogic.checkMinimumRequiredVersion();
    runApp(const Markbase());
  } catch (e) {
    if (e == 'update-required') {
      runApp(const UpdateRequired());
    }
  }
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
              ifFalse: const StartAuthScreen(),
            ),
    );
  }
}
