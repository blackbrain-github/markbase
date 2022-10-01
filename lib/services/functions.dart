import 'package:cloud_functions/cloud_functions.dart';

class Functions {
  static Future<bool> isUsernameAvailable(String username) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('isUsernameAvailable');

    try {
      HttpsCallableResult res = await callable.call({
        'username': username,
      });

      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
