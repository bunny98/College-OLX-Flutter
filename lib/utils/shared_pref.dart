import 'package:ent_new/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefs {
  static SharedPreferences _pref;
  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static String getUserId() {
    return _pref.getString(SHARED_PREF_USER_ID_KEY);
  }

  static Future<void> setUserId({String userId}) async {
    await _pref.setString(SHARED_PREF_USER_ID_KEY, userId);
  }

  static bool isPresent() {
    return _pref.containsKey(SHARED_PREF_USER_ID_KEY);
  }

  static Future<void> removeUser() async {
    await _pref.remove(SHARED_PREF_USER_ID_KEY);
  }
}
