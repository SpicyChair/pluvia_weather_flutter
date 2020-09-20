import 'package:flutter/material.dart';

const kSubheadingTextStyle = TextStyle (
  fontWeight: FontWeight.bold,
  fontSize: 21.0,
  color: Colors.black,
);

const kPanelCardMargin = EdgeInsets.all(10);

const kSubheadingTextMargin = EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0);

const kLargeTempTextStyle = TextStyle(
  fontSize: 120,
  fontWeight: FontWeight.w200,
  color: Colors.white,
);


const kConditionTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w300,
  color: Colors.white,
);


const kBorderRadius = BorderRadius.all(Radius.circular(14.0));

enum WeatherType {
  clearDay,
  clearAfternoon,
  clearEvening,
  clearNight,
  rain,
  snow
}