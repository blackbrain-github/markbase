import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Functions {
  static Future<bool> isUsernameAvailable(String username) async {
    HttpsCallable callable = FirebaseConstants.functions.httpsCallable('isUsernameAvailable');

    try {
      HttpsCallableResult res = await callable.call({
        'username': username,
      });

      print(res.data);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
