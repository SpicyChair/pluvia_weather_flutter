import 'package:flutter/material.dart';
import 'package:flutter_weather/constants.dart';

class HourlyCard extends StatelessWidget {

  //the icon to show weather condition
  final String icon;
  //temp conditions
  final int temp;
  //the time of the forecast
  final String displayTime;

  //extra data to show when card is tapped
  dynamic weatherData;

  HourlyCard({this.icon, this.displayTime, this.temp, this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      child: Container(
        height: 100,
        width: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              displayTime,
              style: kSubheadingTextStyle.copyWith(
                  color: Colors.black54, fontSize: 18),
            ),
            Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[100],
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontSize: 27,
                  ),
                ),
              ),
            ),
            Text(
              "${temp.toString()}°",
              style: kSubheadingTextStyle,
            ),
          ],
        ),
      ),
    );
  }

}