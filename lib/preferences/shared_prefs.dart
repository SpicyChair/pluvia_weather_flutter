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


  static const String themeKey = "themeMode";

  static Future<ThemeModePref> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeModePref mode = ThemeModePref.values[prefs.getInt(themeKey) ?? 2];
    print(mode);
    return mode;
  }

  static Future<void> setThemeMode(ThemeModePref mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, mode.index);
  }

  //values for 24h time

  static const String h24key = "use24h";

  static Future<bool> get24() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if value is none return false
    bool value = prefs.getBool(h24key) ?? true;
    return value;
  }

  static Future<void> set24(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(h24key, newValue);
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




  //values for custom owm api key

  static const String owmKey = "openWeatherKey";

  static Future<String> getOpenWeatherAPIKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString(owmKey) ?? "";
    return code;
  }

  static Future<void> setOpenWeatherAPIKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(owmKey, key);
    print(key.toString());
  }

  //values for custom owm api key

  static const String disclaimerRead = "discRead";

  static Future<bool> getDisclaimerRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool code = prefs.getBool(disclaimerRead) ?? 0;
    return code;
  }

  static Future<void> setDisclaimerRead(bool key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(disclaimerRead, key);
    print(key.toString());
  }


  static const String defaultLocationKey = "defaultLocationKey";

  static Future<List> getDefaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> location = prefs.getStringList(defaultLocationKey);

    if (location != null) {
      return [location[0], double.parse(location[1]), double.parse(location[2])];
    }
    return ["Use a default location on app startup."];
  }

  static Future<void> setDefaultLocation({String text, double lat, double long}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(defaultLocationKey, [text, lat.toString(), long.toString()]);
  }

  static Future<void> removeDefaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(defaultLocationKey);
  }


}




enum WindUnit {
  MS,
  MPH,
  KMPH,
}

enum ThemeModePref {
  LIGHT,
  DARK,
  AUTO,
}