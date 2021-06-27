import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  //values for imperial

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

  //values  for dark mode

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


  //values for wind unit

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


  //values for language

  static const String langKey = "languageCode";

  static Future<String> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString(langKey) ?? "en";
    return code;
  }

  static Future<void> setLanguageCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(langKey, code);
    print(code.toString());
  }


}

enum WindUnit {
  MS,
  MPH,
  KMPH,
}