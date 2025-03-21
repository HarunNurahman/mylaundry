import 'dart:convert';

import 'package:mylaundry/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  // User
  static Future<User?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    String? userString = pref.getString('user');
    if (userString == null) return null;

    var userMap = jsonDecode(userString);
    return User.fromJson(userMap);
  }

  static Future<bool> saveUser(Map userMap) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(userMap);
    bool success = await pref.setString('user', userString);

    return success;
  }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');

    return success;
  }

  // Token
  static Future<String?> getBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('bearer_token');
    return token;
  }

  static Future<bool> saveBearerToken(String bearerToken) async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.setString('bearer_token', bearerToken);

    return success;
  }

  static Future<bool> removeBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('bearer_token');

    return success;
  }
}
