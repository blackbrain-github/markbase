import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppUser {
  static bool exists = FirebaseAuth.instance.currentUser != null;
  static String? id = FirebaseAuth.instance.currentUser?.uid;
  static String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  static String? email = FirebaseAuth.instance.currentUser?.email;
}

class AppColors {
  // \\ // \\ // \\ // \\ // UNIVERSAL \\ // \\ // \\ // \\ // \\

  static const Color accentColor = Color(0xFFFF520D);

  static Color getPrimaryBackgroundColor() => AppVariables.appState.read('theme') == null
      ? primaryBackgroundColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? primaryBackgroundColorLightMode
          : primaryBackgroundColorDarkMode;

  static Color getInversePrimaryBackgroundColor() => AppVariables.appState.read('theme') == null
      ? primaryBackgroundColorDarkMode
      : AppVariables.appState.read('theme') == 'light'
          ? primaryBackgroundColorDarkMode
          : primaryBackgroundColorLightMode;

  static Color getSecondaryBackgroundColor() => AppVariables.appState.read('theme') == null
      ? secondaryBackgroundColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? secondaryBackgroundColorLightMode
          : secondaryBackgroundColorDarkMode;

  static Color getNoteColor() => AppVariables.appState.read('theme') == null
      ? noteColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? noteColorLightMode
          : noteColorDarkMode;

  static Color getShadowColor() => AppVariables.appState.read('theme') == null
      ? shadowColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? shadowColorLightMode
          : shadowColorDarkMode;

  // Text
  static Color getPrimaryTextColor() => AppVariables.appState.read('theme') == null
      ? primaryTextColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? primaryTextColorLightMode
          : primaryTextColorDarkMode;

  static Color getInversePrimaryTextColor() => AppVariables.appState.read('theme') == null
      ? primaryTextColorDarkMode
      : AppVariables.appState.read('theme') == 'light'
          ? primaryTextColorDarkMode
          : primaryTextColorLightMode;

  static Color getSecondaryTextColor() => AppVariables.appState.read('theme') == null
      ? secondaryTextColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? secondaryTextColorLightMode
          : secondaryTextColorDarkMode;

  // Button
  static const Color selectedButtonColor = accentColor;
  static const Color selectedButtonTextColor = Color(0xFFFFFFFF);

  static Color getUnselectedButtonColor() => AppVariables.appState.read('theme') == null
      ? unselectedButtonBackgroundColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? unselectedButtonBackgroundColorLightMode
          : unselectedButtonBackgroundColorDarkMode;

  static const Color unselectedButtonTextColor = Color(0xFFAAAAAA);

  static Color getDisabledButtonColor() => AppVariables.appState.read('theme') == null
      ? disabledButtonBackgroundColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? disabledButtonBackgroundColorLightMode
          : disabledButtonBackgroundColorDarkMode;

  static Color getDisabledButtonTextColor() => AppVariables.appState.read('theme') == null
      ? disabledButtonTextColorLightMode
      : AppVariables.appState.read('theme') == 'light'
          ? disabledButtonTextColorLightMode
          : disabledButtonTextColorDarkMode;

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
  static const Color primaryBackgroundColorDarkMode = Color(0xFF0F0F0F);
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
