import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';

class HourlyCard extends StatelessWidget {
  //the icon to show weather condition
  final String icon;
  //temp conditions
  final int temp;
  //the time of the forecast
  final String displayTime;
  //if the forecast is for the current hour
  final bool isCurrent;

  //extra data to show when card is tapped
  dynamic weatherData;

  HourlyCard(
      {this.icon,
      this.displayTime,
      this.temp,
      this.weatherData,
      this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
        side: BorderSide(
          color: isCurrent ? Colors.blueAccent.withOpacity(0.7) : Colors.transparent,
          width: 3.5,
        ),
      ),
      child: InkWell(
        borderRadius: kBorderRadius,
        onTap: () {},
        child: Container(
          height: 100,
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                displayTime,
                style: kHourlyCardTime,
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
                    style: kHourlyCardIcon,
                  ),
                ),
              ),
              Text(
                "${temp.toString()}°",
                style: kHourlyCardTemperature,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
