import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static const String imperialKey = "useImperial";

  static Future<bool> getImperial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if value is none return false
    bool value = prefs.getBool(imperialKey) ?? false;
    return value;
  }

  static Future<void> setImperial(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(imperialKey, newValue);
  }

}