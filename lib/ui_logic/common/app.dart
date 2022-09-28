import 'package:Markbase/ui_logic/common/common_logic.dart' as Common;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';

class AppColors {
  // \\ // \\ // \\ // \\ // UNIVERSAL \\ // \\ // \\ // \\ // \\

  static bool isLightMode() => AppVariables.appState.read('theme') == null || AppVariables.appState.read('theme') == 'system'
      ? SchedulerBinding.instance.window.platformBrightness == Brightness.light
          ? true
          : false
      : AppVariables.appState.read('theme') == 'light'
          ? true
          : false;

  static const Color accentColor = Color(0xFFFF520D);

  static Color getPrimaryBackgroundColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return primaryBackgroundColorLightMode;
      } else {
        return primaryBackgroundColorDarkMode;
      }
    } else {
      return isLightMode() ? primaryBackgroundColorLightMode : primaryBackgroundColorDarkMode;
    }
  }

  static Color getInversePrimaryBackgroundColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return primaryBackgroundColorDarkMode;
      } else {
        return primaryBackgroundColorLightMode;
      }
    } else {
      return isLightMode() ? primaryBackgroundColorDarkMode : primaryBackgroundColorLightMode;
    }
  }

  static Color getSecondaryBackgroundColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return secondaryBackgroundColorLightMode;
      } else {
        return secondaryBackgroundColorDarkMode;
      }
    } else {
      return isLightMode() ? secondaryBackgroundColorLightMode : secondaryBackgroundColorDarkMode;
    }
  }

  static Color getNoteColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return noteColorLightMode;
      } else {
        return noteColorDarkMode;
      }
    } else {
      return isLightMode() ? noteColorLightMode : noteColorDarkMode;
    }
  }

  static Color getShadowColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return shadowColorLightMode;
      } else {
        return shadowColorDarkMode;
      }
    } else {
      return isLightMode() ? shadowColorLightMode : shadowColorDarkMode;
    }
  }

  // Text
  static Color getPrimaryTextColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return primaryTextColorLightMode;
      } else {
        return primaryTextColorDarkMode;
      }
    } else {
      return isLightMode() ? primaryTextColorLightMode : primaryTextColorDarkMode;
    }
  }

  static Color getInversePrimaryTextColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return primaryTextColorDarkMode;
      } else {
        return primaryTextColorLightMode;
      }
    } else {
      return isLightMode() ? primaryTextColorDarkMode : primaryTextColorLightMode;
    }
  }

  static Color getSecondaryTextColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return secondaryTextColorLightMode;
      } else {
        return secondaryTextColorDarkMode;
      }
    } else {
      return isLightMode() ? secondaryTextColorLightMode : secondaryTextColorDarkMode;
    }
  }

  // Button
  static const Color selectedButtonColor = accentColor;
  static const Color selectedButtonTextColor = Color(0xFFFFFFFF);

  static Color getUnselectedButtonColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return unselectedButtonBackgroundColorLightMode;
      } else {
        return unselectedButtonBackgroundColorDarkMode;
      }
    } else {
      return isLightMode() ? unselectedButtonBackgroundColorLightMode : unselectedButtonBackgroundColorDarkMode;
    }
  }

  static const Color unselectedButtonTextColor = Color(0xFFAAAAAA);

  static Color getDisabledButtonColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return disabledButtonBackgroundColorLightMode;
      } else {
        return disabledButtonBackgroundColorDarkMode;
      }
    } else {
      return isLightMode() ? disabledButtonBackgroundColorLightMode : disabledButtonBackgroundColorDarkMode;
    }
  }

  static Color getDisabledButtonTextColor({Common.Theme? theme}) {
    if (theme != null) {
      if (theme == Common.Theme.light) {
        return disabledButtonTextColorLightMode;
      } else {
        return disabledButtonTextColorDarkMode;
      }
    } else {
      return isLightMode() ? disabledButtonTextColorLightMode : disabledButtonTextColorDarkMode;
    }
  }

  // \\ // \\ // \\ // \\ // LIGHT \\ // \\ // \\ // \\ // \\

  // General
  static const Color primaryBackgroundColorLightMode = Color(0xFFF5F5F5);
  static const Color secondaryBackgroundColorLightMode = Color(0xFFFFFFFF);
  static const Color noteColorLightMode = Color(0xFFFFFFFF);
  static Color shadowColorLightMode = const Color(0xFF000000).withOpacity(0.05);

  // Text
  static const Color primaryTextColorLightMode = Color(0xFF000000);
  static const Color secondaryTextColorLightMode = Color(0xFFC1C1C1);

  // Button
  static const Color selectedButtonBackgroundColorLightMode = accentColor;
  static const Color selectedButtonTextColorLightMode = Color(0xFFFFFFFF);
  static const Color unselectedButtonBackgroundColorLightMode = Color(0xFFE7E7E7);
  static const Color unselectedButtonTextColorLightMode = Color(0xFFAAAAAA);
  static const Color disabledButtonBackgroundColorLightMode = Color(0xFFFFEEE7);
  static const Color disabledButtonTextColorLightMode = Color(0xFFFFFFFF);

  // \\ // \\ // \\ // \\ // DARK \\ // \\ // \\ // \\ // \\

  // General
  static const Color primaryBackgroundColorDarkMode = Color(0xFF000000);
  static const Color secondaryBackgroundColorDarkMode = Color(0xFF202020);
  static const Color noteColorDarkMode = Color(0xFF202020);
  static Color shadowColorDarkMode = const Color(0xFF000000).withOpacity(0.025);

  // Text
  static const Color primaryTextColorDarkMode = Color(0xFFFFFFFF);
  static const Color secondaryTextColorDarkMode = Color(0xFF636363);

  // Button
  static const Color selectedButtonBackgroundColorDarkMode = accentColor;
  static const Color selectedButtonTextColorDarkMode = Color(0xFFFFFFFF);
  static const Color unselectedButtonBackgroundColorDarkMode = Color(0xFF2B2B2B);
  static const Color unselectedButtonTextColorDarkMode = Color(0xFFAAAAAA);
  static const Color disabledButtonBackgroundColorDarkMode = Color(0xFF352A26);
  static const Color disabledButtonTextColorDarkMode = Color(0xFF9A9593);
}

class AppVariables {
  static GetStorage appState = GetStorage();
}
