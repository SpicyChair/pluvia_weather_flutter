
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';


void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Pluvia Weather",
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

