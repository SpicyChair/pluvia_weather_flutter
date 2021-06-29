import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/components/daily_card.dart';
import 'package:flutter_weather/components/hourly_card.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:intl/intl.dart';
import 'package:flutter_weather/services/weather_model.dart';

import 'home_screen.dart';

class DailyForecastScreen extends StatefulWidget {
  final Function onChooseLocationPressed;
  DailyForecastScreen({this.onChooseLocationPressed});
  @override
  _DailyForecastScreenState createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  var dailyData;
  double lat;
  double lon;
  bool imperial;
  WindUnit unit;

  bool isLoading = true;

  void initState() {
    super.initState();
    if (WeatherModel.weatherData != null) {
      updateUI();
    }
  }

  Future<void> updateUI() async {
    dailyData = WeatherModel.weatherData["daily"];
    lat = WeatherModel.weatherData["lat"].toDouble();
    lon = WeatherModel.weatherData["lon"].toDouble();

    imperial = await SharedPrefs.getImperial();
    unit = await SharedPrefs.getWindUnit();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dailyData == null) {
      return Scaffold(
        backgroundColor: ThemeColors.backgroundColor(),
        body: Center(
          child: Text(
            dailyData == null
                ? Language.getTranslation("chooseLocationToView")
                : Language.getTranslation("loading"),
            style: TextStyle(
              color: ThemeColors.primaryTextColor(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Text(
          WeatherModel.locationName,
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 30,
            color: ThemeColors.primaryTextColor(),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              onPressed: refresh,
              child: Icon(
                Icons.refresh_outlined,
                size: 27,
                color: ThemeColors.primaryTextColor(),
              ),
            ),
          )
        ],
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      body: isLoading
          ?
          //if is loading
      Center(
          child: Column(
            children: [
              SpinKitFadingCircle(color: ThemeColors.secondaryTextColor(), size: 50,),
              SizedBox(height: 20,),
              Text(Language.getTranslation("loading"), style: TextStyle(color: ThemeColors.secondaryTextColor()),),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
      )
          :
          //if loaded
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DailyCard(
                        data: dailyData[index + 1],
                        imperial: imperial,
                        unit: unit,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    itemCount: 7,
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> refresh() async {
    await WeatherModel.getCoordLocationWeather(
        lat, lon, WeatherModel.locationName);
    updateUI();
    DateTime now = DateTime.now();
    String refreshTime = DateFormat.Hm().format(now);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("${Language.getTranslation("lastUpdatedAt")} $refreshTime")));
  }
}
