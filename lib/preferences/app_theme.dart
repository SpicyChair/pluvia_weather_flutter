import 'package:flutter/material.dart';


final ThemeData lightThemeData = ThemeData.light().copyWith(
    brightness: Brightness.light,
    backgroundColor: Colors.grey[50],
    canvasColor: Colors.grey[50],
    cardColor: Colors.white,
    primaryColorLight: Colors.black,
    primaryColorDark: Colors.black54,
    useMaterial3: true,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
    ),
);

final ThemeData darkThemeData = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  canvasColor: Colors.black,
  cardColor: Colors.grey[900],
  accentColor: Colors.blueAccent,
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.grey[400],
  useMaterial3: true,
  floatingActionButtonTheme:
  FloatingActionButtonThemeData(backgroundColor: Colors.blueAccent),
);
