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


  static const String darkKey = "useDarkMode";

  static Future<bool> getDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if value is none return false
    bool value = prefs.getBool(darkKey) ?? false;
    return value;
  }

  static Future<void> setDark(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkKey, newValue);
  }



  static const String windKey = "windUnit";

  static Future<WindUnit> getWindUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WindUnit unit = WindUnit.values[prefs.getInt(windKey) ?? 0];
    return unit;
  }

  static Future<void> setWindUnit(WindUnit unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(windKey, unit.index);
    print(unit.toString());
  }
}

enum WindUnit {
  MS,
  MPH,
  KMPH,
}