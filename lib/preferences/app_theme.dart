import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'shared_prefs.dart';

class AppThemeChangeNotifier extends ChangeNotifier {

  var themeMode = ThemeModePref.AUTO;


  Future<void> initialize() async {
    themeMode = await SharedPrefs.getThemeMode();
    notifyListeners();
  }

  void setThemeMode(ThemeModePref mode) {
    themeMode = mode;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    switch (themeMode) {
      case ThemeModePref.LIGHT:
        return ThemeMode.light;
        break;
      case ThemeModePref.DARK:
        return ThemeMode.dark;
        break;
      default:
        return ThemeMode.system;
        break;
    }

  }

}