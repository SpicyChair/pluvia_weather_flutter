import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:provider/provider.dart';

import '../preferences/app_theme.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
  bool checkDefaultLocation;

  LoadingScreen({this.checkDefaultLocation = false});
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isGettingData;
  bool correctAPIKeys;
  String message;

  Future getThemeMode() async {
    await Provider.of<AppThemeChangeNotifier>(context, listen: false)
        .initialize();
  }

  Future getWeatherData() async {
    isGettingData = true;
    correctAPIKeys = true;
    message = Language.getTranslation("loading");
    int result = 0;

    if (widget.checkDefaultLocation) {
      var data = await SharedPrefs.getDefaultLocation();
      if (data.length == 3) {
        result = await WeatherModel.getCoordLocationWeather(
            name: data[0], latitude: data[1], longitude: data[2]);
      } else {
        result = await WeatherModel.getUserLocationWeather();
      }
    } else {
      result = await WeatherModel.getUserLocationWeather();
    }

    /*

     */

    if (result == 0) {
      setState(() {
        isGettingData = false;
        message = Language.getTranslation("networkErrorText");
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

    await SharedPrefs.getLanguageCode();
    await SharedPrefs.getWindUnit();
    await SharedPrefs.getImperial();
    await SharedPrefs.getDark();

    TimeHelper.initialize();
  }

  @override
  void initState() {
    super.initState();
    getThemeMode();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.grey[200],
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pluvia_circle_icon.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 273,
            child: Text(
              "PLUVIA",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight,
                fontSize: 23,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //show message depending on status
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isGettingData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      size: 27,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Visibility(
                  //show only when data is unavailable
                  visible: !isGettingData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        Language.getTranslation("retry"),
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark),
                      ),
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
                Visibility(
                  //show only when api keys are bad
                  visible: !correctAPIKeys,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text(
                        "Edit API Keys",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight),
                      ), //TODO: TRANSLATE STRINGS
                      //Language.getTranslation("editAPIKeys")
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
                SizedBox(
                  height: 30,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
