import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/home_screen.dart';
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
        useMaterial3: true,
        primaryColor: Colors.blueAccent,
        //backgroundColor: Colors.black,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blueAccent),
      ),
      debugShowCheckedModeBanner: true,
      home: LoadingScreen(checkDefaultLocation: true,),
    );
  }
}
