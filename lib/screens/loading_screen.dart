import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter_weather/services/weather_receiver.dart';
import 'current_weather_screen.dart';
import 'package:app_settings/app_settings.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  bool isGettingData;
  String message;

  Future getWeatherData() async {
    isGettingData = true;
    message = "Getting weather data...";
    
    var weatherData = await WeatherModel().getUserLocationWeather();

    //bad request / internet disabled
    if (weatherData == 0) {
      setState(() {
        isGettingData = false;
        message = "Enable WIFI or data and retry";
      });
      return;
    }
    //user denied location or location is disabled
    // show select location screen
    if (weatherData == 1) {
      print(weatherData);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => SavedLocationScreen(locationDisabledInitially: true,),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isGettingData,
                child: SpinKitDualRing(
                  size: 100,
                  color: Colors.blueAccent,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: 300,
                child: Column(
                  children: [
                    //show message depending on status
                    Text(message, style: TextStyle(
                      fontSize: 14,
                    ),),
                    Visibility(
                      //show only when data is unavailable
                      visible: !isGettingData,
                      child: FlatButton(child: Text("RETRY"),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => LoadingScreen(),
                          ),);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
