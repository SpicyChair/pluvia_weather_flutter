import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'screens/loading_screen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  getThemeColors();
}

Future<void> getThemeColors() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeColors.initialise().then(
    (value) => runApp(
      Phoenix(
        child: WeatherApp(),
      ),
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
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blueAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
