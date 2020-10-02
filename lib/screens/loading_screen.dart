import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pluvia Weather",
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                letterSpacing: 2),
              ),
              Visibility(
                visible: isGettingData,
                child: Padding(
                  padding: const EdgeInsets.all(33.0),
                  child: SpinKitDualRing(
                    size: 70,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Column(
                children: [
                  //show message depending on status
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    //show only when data is unavailable
                    visible: !isGettingData,
                    child: RaisedButton(
                      child: Text("RETRY"),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
