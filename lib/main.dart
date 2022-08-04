import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_weather/preferences/app_theme.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'screens/loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() {
  initialize();
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Language.initialise();
  await DotEnv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppThemeChangeNotifier(),
      child: WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AppThemeChangeNotifier>(context, listen: true).initialize();
    });

    return MaterialApp(
      title: "Pluvia Weather",
      themeMode: Provider.of<AppThemeChangeNotifier>(context, listen: true).getThemeMode(),
      theme: lightThemeData,
      darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(
        checkDefaultLocation: true,
      ),
    );
  }
}

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
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.grey[400],
  useMaterial3: true,
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Colors.blueAccent),
);
