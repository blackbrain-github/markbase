import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/user.dart';
import 'package:Markbase/services/database.dart';

class CommonLogic {
  static final VariableNotifier<bool?> isLoggedIn = VariableNotifier<bool?>(null);
  static final VariableNotifier<Theme> theme = VariableNotifier<Theme>(AppVariables.appState.read('theme') == null
      ? Theme.light
      : AppVariables.appState.read('theme') == 'light'
          ? Theme.light
          : Theme.dark);
  static final VariableNotifier<UserModel?> appUser = VariableNotifier<UserModel?>(null);
  static final VariableNotifier<String?> localVersion = VariableNotifier<String?>(null);
  static final VariableNotifier<String?> latestVersion = VariableNotifier<String?>(null);

  static Future<void> getAppUser({bool notify = false}) async {
    try {
      UserModel user = await Database.get.user();
      Map<String, dynamic>? cachedUserModel = AppVariables.appState.read('user');

      if (cachedUserModel != user.toMap()) {
        appUser.set(user, notify: notify);
        await AppVariables.appState.write('user', user.toMap());
      }
    } catch (e) {
      if (e == 'not-found') {
        isLoggedIn.set(false);
        await AppVariables.appState.write('user', null);
      } else {
        isLoggedIn.set(false);
        await AppVariables.appState.write('user', null);
      }
    }
  }
}

enum Theme { light, dark }
