import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'current_weather_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isGettingData;
  String message;

  Future getWeatherData() async {
    isGettingData = true;
    message = "Getting location...";


    if (await WeatherModel.getUserLocationWeather() == 0) {
      setState(() {
        isGettingData = false;
        message = "Please enable WIFI or Data and retry";
      });
      return;
    }

    await loadSharedPrefs();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  Future<void> loadSharedPrefs() async {
    //loads shared prefs into local variables
    //so they can be accessed without future
    await SharedPrefs.getWindUnit();
    await SharedPrefs.getImperial();
    await SharedPrefs.getDark();
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeColors.backgroundColor(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pluvia Weather",
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: ThemeColors.primaryTextColor(),
                letterSpacing: 2),
              ),
            ),
            Visibility(
              visible: isGettingData,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SpinKitThreeBounce(
                  size: 50,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Column(
              children: [
                //show message depending on status
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.secondaryTextColor(),
                    ),
                  ),
                ),
                Visibility(
                  //show only when data is unavailable
                  visible: !isGettingData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("RETRY", style: TextStyle(color: ThemeColors.primaryTextColor()),),
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
