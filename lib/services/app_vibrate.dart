import 'dart:io';

import 'package:flutter_vibrate/flutter_vibrate.dart';

class AppVibrate {
  static void light() async {
    if (Platform.isIOS) {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.light);
      }
    }
  }

  static void medium() async {
    if (Platform.isIOS) {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.medium);
      }
    }
  }

  static void impact() async {
    if (Platform.isIOS) {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.impact);
      }
    }
  }
}
