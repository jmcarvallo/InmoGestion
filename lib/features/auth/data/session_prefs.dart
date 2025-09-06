import 'package:shared_preferences/shared_preferences.dart';

class SessionPrefs {
  static const _kLoggedIn = 'logged_in';
  static const _kUsername = 'username';

  Future<void> setLoggedIn(String username) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kLoggedIn, true);
    await sp.setString(_kUsername, username);
  }

  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kLoggedIn);
    await sp.remove(_kUsername);
  }

  Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kLoggedIn) ?? false;
  }

  Future<String?> username() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUsername);
  }
}
