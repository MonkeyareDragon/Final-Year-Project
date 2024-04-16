import 'package:loginsignup/model/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserId = 'userId';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyFirstName = 'firstName';
  static const String _keyLastName = 'lastName';
  static const String _firstTimeKey = 'is_first_time';

  static Future<void> saveSession(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyUserId, session.userId);
    prefs.setString(_keyAccessToken, session.accessToken);
    prefs.setString(_keyFirstName, session.firstName);
    prefs.setString(_keyLastName, session.lastName);
  }

  static Future<UserSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_keyUserId);
    final accessToken = prefs.getString(_keyAccessToken);
    final firstName = prefs.getString(_keyFirstName);
    final lastName = prefs.getString(_keyLastName);

    if (userId != null &&
        accessToken != null &&
        firstName != null &&
        lastName != null) {
      return UserSession(
          userId: userId,
          accessToken: accessToken,
          firstName: firstName,
          lastName: lastName);
    }

    return null;
  }

  static Future<bool> isFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isFirstTime = prefs.getBool(_firstTimeKey);

    if (isFirstTime == null) {
      await prefs.setBool(_firstTimeKey, false);
      return true;
    }
    return isFirstTime;
  }

  static Future<void> setIsNotFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUserId);
    prefs.remove(_keyAccessToken);
    prefs.remove(_keyFirstName);
    prefs.remove(_keyLastName);
  }
}
