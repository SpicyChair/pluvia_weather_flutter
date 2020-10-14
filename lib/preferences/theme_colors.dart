import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';


class ThemeColors {
  static bool isDark;

  static void switchTheme(bool value) {
    isDark = value;
    SharedPrefs.setDark(value);
  }

  static Future<void> initialise() async {
    isDark = await SharedPrefs.getDark();
  }

  static Color backgroundColor() => isDark ? Colors.black : Colors.grey[50];
  static Color cardColor() => isDark ? Colors.grey[900] : Colors.white;
  static Color primaryTextColor() => isDark ? Colors.white : Colors.black87;
  static Color secondaryTextColor() => isDark ? Colors.grey[400] : Colors.black54;
}