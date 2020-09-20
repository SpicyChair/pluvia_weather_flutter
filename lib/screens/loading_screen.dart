import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter_weather/services/weather_receiver.dart';
import 'weather_screen.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  Future getWeatherData() async {
    var weatherData = await WeatherModel().getUserLocationWeather();
    //send user to the saved location screen if location disabled
    if (weatherData == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => SavedLocationScreen(),
      ));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => WeatherScreen(weather: weatherData, title: "Current Location",),
    ),);
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Center(
          child: SpinKitDualRing(
            size: 100,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
