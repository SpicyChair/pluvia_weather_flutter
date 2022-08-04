import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:flutter_weather/services/extensions.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'info_card.dart';

class HourlyCard extends StatelessWidget {
  final BuildContext context;
  //the icon to show weather condition
  final String icon;
  //temp conditions
  final int temp;
  //the time of the forecast to be displayed
  final String displayTime;
  //if the forecast is for the current hour
  final bool isCurrent;
  //date of forecast
  final DateTime forecastTime;
  //extra data to show when card is tapped
  final dynamic weatherData;
  //probability of precipitation
  final int pop;

  HourlyCard(
      {this.context,
      this.icon,
      this.displayTime,
      this.forecastTime,
      this.temp,
      this.weatherData,
      this.pop,
      this.isCurrent});



  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'View weather for the selected hour',
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius,
          side: BorderSide(
            color: isCurrent
                ? Colors.blueAccent.withOpacity(0.7)
                : Colors.transparent,
            width: 3.5,
          ),
        ),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: kBorderRadius,
          onTap: () {
            showInfoDialog();
          },
          child: Container(
            height: 100,
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  displayTime,
                  textAlign: TextAlign.center,
                  style: kHourlyCardTime.copyWith(
                      color: Theme.of(context).primaryColorDark),
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: kHourlyCardIcon,
                    ),
                  ),
                ),
                Text(
                  "${temp.toString()}°",
                  style: kHourlyCardTemperature.copyWith(
                      color: Theme.of(context).primaryColorLight),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.opacity_outlined,
                      size: 14,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "$pop%",
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<String> parseData() async {
    bool imperial = await SharedPrefs.getImperial();
    WindUnit unit = await SharedPrefs.getWindUnit();

    double windSpeed =  await WeatherModel.convertWindSpeed(weatherData["wind_speed"]?.round(), unit, imperial);
    int windDirection = weatherData["wind_deg"]?.round();
    String unitString =  await WeatherModel.getWindUnitString(unit);
    return "${windSpeed.round()} $unitString ${WeatherModel.getWindCompassDirection(windDirection)}";
  }

  void showInfoDialog() {
    String description = weatherData["weather"][0]["description"];
    int temperature = weatherData["temp"]?.round();
    double feelTemp = weatherData["feels_like"]?.toDouble();
    int humidity = weatherData["humidity"]?.round();
    int pressure = weatherData["pressure"]?.round();
    String windValue;
    parseData().then((value) => windValue = value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
          backgroundColor: Theme.of(context).cardColor,
          insetPadding: EdgeInsets.all(20),
          title: Center(
            child: Text(
              "$displayTime  |  ${DateFormat.MMMEd().format(forecastTime)}",
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          content: Container(
            width: 300,
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).backgroundColor,
                  ),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            icon,
                            style: kHourlyCardIcon,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        description.toTitleCase(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 250,
                  width: 300,
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 2,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      InfoCard(
                        title: Language.getTranslation("temperature"),
                        value: "${temperature.toString()}°",
                      ),
                      InfoCard(
                        title: Language.getTranslation("feelsLike"),
                        value: "${feelTemp.toString()}°",
                      ),
                      InfoCard(
                        title: Language.getTranslation("wind"),
                        value:
                        windValue,
                      ),
                      InfoCard(
                        title: Language.getTranslation("precipitation"),
                        value: "${pop.toString()}%",
                      ),
                      InfoCard(
                        title: Language.getTranslation("humidity"),
                        value: "${humidity.toString()}%",
                      ),
                      InfoCard(
                        title: Language.getTranslation("pressure"),
                        value: "${pressure.toString()} hPa",
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Language.getTranslation("close"), style: TextStyle(
                color: Theme.of(context).primaryColorDark,
              ),),
            )
          ],
        );
      },
    );
  }
}
