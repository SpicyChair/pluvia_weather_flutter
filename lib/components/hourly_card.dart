import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
        side: BorderSide(
          color: isCurrent
              ? Colors.blueAccent.withOpacity(0.7)
              : Colors.transparent,
          width: 3.5,
        ),
      ),
      color: ThemeColors.cardColor(),
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
                style: kHourlyCardTime.copyWith(
                    color: ThemeColors.secondaryTextColor()),
              ),
              Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ThemeColors.backgroundColor(),
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
                    color: ThemeColors.primaryTextColor()),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.opacity_outlined,
                    size: 14,
                    color: ThemeColors.secondaryTextColor(),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "$pop%",
                    style: TextStyle(
                      fontSize: 15,
                      color: ThemeColors.secondaryTextColor(),
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
  Future<String> parseData() async {
    double windSpeed = await WeatherModel.convertWindSpeed(weatherData["wind_speed"]?.round());
    String unit = await WeatherModel.getWindUnit();
    return "${windSpeed.round()} $unit";
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
          backgroundColor: ThemeColors.cardColor(),
          insetPadding: EdgeInsets.all(20),
          title: Center(
            child: Text(
              "$displayTime  |  ${DateFormat.MMMEd().format(forecastTime)}",
              style: TextStyle(
                color: ThemeColors.primaryTextColor(),
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
                    color: ThemeColors.backgroundColor(),
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
                          color: ThemeColors.primaryTextColor(),
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
                    childAspectRatio: 2,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      InfoCard(
                        title: "Temperature",
                        value: "${temperature.toString()}°",
                      ),
                      InfoCard(
                        title: "Feels like",
                        value: "${feelTemp.toString()}°",
                      ),
                      InfoCard(
                        title: "Wind",
                        value:
                        windValue,
                      ),
                      InfoCard(
                        title: "Precipitation",
                        value: "${pop.toString()}%",
                      ),
                      InfoCard(
                        title: "Humidity",
                        value: "${humidity.toString()}%",
                      ),
                      InfoCard(
                        title: "Pressure",
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
              child: Text("CLOSE"),
            )
          ],
        );
      },
    );
  }
}
