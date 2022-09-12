import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/ui_logic/common/app.dart';

class CommonLogic {
  static final VariableNotifier<bool?> isLoggedIn = VariableNotifier<bool?>(null);
  static final VariableNotifier<Theme> theme = VariableNotifier<Theme>(AppVariables.appState.read('theme') == null
      ? Theme.light
      : AppVariables.appState.read('theme') == 'light'
          ? Theme.light
          : Theme.dark);
}

enum Theme { light, dark }
