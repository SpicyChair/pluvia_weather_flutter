import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'package:flutter/services.dart';

void main() {
  getThemeColorsAndLang();
}

Future<void> getThemeColorsAndLang() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Language.initialise();
  ThemeColors.initialise().then(
    (value) => runApp(
      WeatherApp(),
    ),
  );

}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Pluvia Weather",
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blueAccent,
        //backgroundColor: Colors.black,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blueAccent),
      ),

      debugShowCheckedModeBanner: false,




      home: LoadingScreen(),
    );
  }
}
