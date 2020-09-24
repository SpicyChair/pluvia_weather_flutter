import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';

class SevenDayForecastScreen extends StatefulWidget {
  @override
  _SevenDayForecastScreenState createState() => _SevenDayForecastScreenState();
}

class _SevenDayForecastScreenState extends State<SevenDayForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next 7 Days"),
      ),
      body: Center(
        child: Text("Coming Soon"),
      ),
    );
  }
}
