import 'dart:ui';

import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/animation/weather_animation.dart';
import 'package:flutter_weather/components/info_card.dart';
import 'file:///E:/flutter_weather/lib/constants/constants.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:flutter_weather/components/panel_card.dart';
import 'package:flutter_weather/components/hourly_card.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  final weather;
  final String title;
  //get the weather from loading screen
  @override
  WeatherScreen({this.weather, this.title});
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //animation for the current time / weather

  WeatherAnimation weatherAnimation = new WeatherAnimation();
  //for converting from epoch to human
  TimeHelper timeHelper = TimeHelper();

  DateTime weatherTime; //the time from the forecast
  DateTime sunriseTime; //sunrise
  DateTime sunsetTime; //sunset

  String cityName;
  String conditionDescription;

  int temperature; //actual temperature, celsius for metric, fahrenheit for imperial
  double feelTemp; //what the temperature feels like (to one dp for accuracy)
  double uvIndex; //the UV index at midday
  int pressure;
  int humidity;

  int windSpeed; //wind speed in m/s for metric, mph for imperial
  int windDirection; //the angle of the wind direction in degrees

  int timeZoneOffset;

  var condition;
  List<dynamic> hourlyData;
  List<dynamic> dailyData;

  @override
  void initState() {
    super.initState();

    updateUI(widget.weather, widget.title);
  }

  void updateUI(dynamic weatherData, String title) {
    timeZoneOffset = weatherData["timezone_offset"].toInt();
    DateTime dateTime = timeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["dt"], timeZoneOffset);

    int conditionCode = weatherData["current"]["weather"][0]["id"];

    print(conditionCode);

    WeatherType weatherType;

    //check if its raining or snowing to show weather animation
    if (conditionCode >= 300 && conditionCode <= 599) {
      //rain / drizzle
      weatherType = WeatherType.rain;
    } else if (conditionCode >= 600 && conditionCode <= 699) {
      //snow
      weatherType = WeatherType.snow;
    } else {
      //use the time instead to show animation as weather is clear
      int hour = dateTime.hour;

      if (hour >= 6 && hour <= 13) {
        //morning
        weatherType = WeatherType.clearDay;
      } else if (hour >= 14 && hour <= 18) {
        //afternoon
        weatherType = WeatherType.clearAfternoon;
      } else if (hour >= 19 && hour <= 21) {
        //evening
        weatherType = WeatherType.clearEvening;
      } else {
        //night
        weatherType = WeatherType.clearNight;
      }
    }

    print(weatherType);

    setState(() {
      //update all values
      cityName = title;

      temperature = weatherData["current"]["temp"].round();

      feelTemp = weatherData["current"]["feels_like"].toDouble();

      uvIndex = weatherData["current"]["uvi"].toDouble();

      humidity = weatherData["current"]["humidity"].round();

      pressure = weatherData["current"]["pressure"].round();

      sunriseTime = timeHelper.getDateTimeSinceEpoch(
          weatherData["current"]["sunrise"].toInt(), timeZoneOffset);

      sunsetTime = timeHelper.getDateTimeSinceEpoch(
          weatherData["current"]["sunset"].toInt(), timeZoneOffset);

      windSpeed = weatherData["current"]["wind_speed"].round();

      windDirection = weatherData["current"]["wind_deg"].round();

      conditionDescription =
          weatherData["current"]["weather"][0]["description"];

      hourlyData = weatherData["hourly"];

      dailyData = weatherData["daily"];
    });

    //if assets are not loaded yet, set the initial weather to build
    if (weatherAnimation.state == null) {
      weatherAnimation.initialWeather = weatherType;
      return;
    }
    //else set the weather normally
    weatherAnimation.state.weatherWorld.weatherType = weatherType;
  }

  WeatherType getWeatherType(DateTime sunrise, DateTime sunset,
      DateTime currentTime, int conditionCode) {
    WeatherType weatherType;
    //check if its raining or snowing to show weather animation
    if (conditionCode >= 300 && conditionCode <= 599) {
      //rain / drizzle
      weatherType = WeatherType.rain;
    } else if (conditionCode >= 600 && conditionCode <= 699) {
      //snow
      weatherType = WeatherType.snow;
    } else {
      //use the time instead to show animation as weather is clear
      int hour = currentTime.hour;

      if (hour >= 6 && hour <= 13) {
        //morning
        weatherType = WeatherType.clearDay;
      } else if (hour >= 14 && hour <= 18) {
        //afternoon
        weatherType = WeatherType.clearAfternoon;
      } else if (hour >= 19 && hour <= 21) {
        //evening
        weatherType = WeatherType.clearEvening;
      } else {
        //night
        weatherType = WeatherType.clearNight;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          cityName,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  List data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedLocationScreen(
                        locationDisabledInitially: false,
                      ),
                    ),
                  );
                  if (data != null) {
                    updateUI(data[0], data[1]);
                  }
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          weatherAnimation,
          temperatureWidget(),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 85,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  //physics: PageScrollPhysics(),
                  children: [
                    //add a spacer
                    SizedBox(
                      height: 300,
                    ),
                    /*
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "NEXT 7 DAYS",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,),
                      ),
                    ),

                     */
                    createMainInfoCard(),
                    createHourlyForecastCard(),
                    createExtraInfoCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget temperatureWidget() {
    return Positioned(
      top: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            child: Text(
              "${temperature.toString()}°",
              style: kLargeTempTextStyle,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              conditionDescription,
              textAlign: TextAlign.center,
              style: kConditionTextStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget createHourlyForecastCard() {
    return PanelCard(
      cardChild: Container(
        height: 240,
        width: double.infinity,
        margin: kPanelCardMargin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: kSubheadingTextMargin,
              child: Text(
                "Hourly",
                style: kSubheadingTextStyle,
              ),
            ),
            Container(
              height: 180,
              width: double.infinity,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  int temp;
                  String icon;
                  DateTime forecastTime;
                  String displayTime;
                  var weatherData;

                  if (hourlyData[index] == null) {
                    temp = 0;
                    icon = "☀";
                    displayTime = "00:00";
                  } else {
                    temp = hourlyData[index]["temp"].round();

                    forecastTime = timeHelper.getDateTimeSinceEpoch(
                        hourlyData[index]["dt"], timeZoneOffset);
                    displayTime = "${forecastTime.hour.toString()}:00";

                    icon = getIconByTimeAndID(
                        hourlyData[index]["weather"][0]["id"],
                        forecastTime,
                        sunsetTime,
                        sunriseTime);
                  }

                  weatherData = hourlyData[index];

                  return HourlyCard(
                    icon: icon,
                    temp: temp,
                    displayTime: displayTime,
                    weatherData: weatherData,
                    isCurrent: index == 0,
                  );
                },
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getIconByTimeAndID(
      int id, DateTime forecastTime, DateTime sunset, DateTime sunrise) {
    //get the time of tomorrow's sunrise
    DateTime tomorrowSunrise = timeHelper.getDateTimeSinceEpoch(
        dailyData[1]["sunrise"], timeZoneOffset);

    //check if time is between sunrise and sunset, or before sunrise
    bool isNight =
        (forecastTime.isAfter(sunset) || forecastTime.isBefore(sunrise)) &&
            forecastTime.isBefore(tomorrowSunrise);

    if (id < 300) {
      //thunderstorms
      if (id <= 202 || id >= 230) {
        //thunderstorms with rain
        return "⛈";
      } else {
        return "🌩️";
      }
    } else if (id < 600) {
      // rain / drizzle
      return "🌧️";
    } else if (id < 700) {
      //snow
      return "❄";
    } else if (id < 800) {
      //atmosphere
      return "🌫️";
    } else if (id == 800) {
      //clear
      return isNight ? "🌘" : "☀";
    } else if (id == 801) {
      // partly cloudy
      return isNight ? "🌘" : "⛅";
    } else if (id == 802) {
      //a bit cloudier than partly cloudy
      return isNight ? "🌘" : "🌥️";
    } else {
      //cloudy
      return "☁";
    }
  }

  Widget createMainInfoCard() {
    final double itemHeight = 80;
    final double itemWidth = MediaQuery.of(context).size.width / 2;

    return PanelCard(
      cardChild: Container(
        height: 75,
        width: double.infinity,
        margin: kPanelCardMargin,
        child: GridView.count(
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InfoCard(
              title: "Feels like",
              value: "${feelTemp.toString()}°",
            ),
            InfoCard(
              title: "Wind",
              value:
                  "${windSpeed.toString()} m/s ${getWindCompassDirection(windDirection)}",
            ),
          ],
        ),
      ),
    );
  }

  String getWindCompassDirection(int angle) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[((angle / 45) % 8).floor()];
  }

  Widget createExtraInfoCard() {
    final double itemHeight = 80;
    final double itemWidth = MediaQuery.of(context).size.width / 2;

    return PanelCard(
      cardChild: Container(
        height: 150,
        width: double.infinity,
        margin: kPanelCardMargin,
        child: GridView.count(
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InfoCard(
              title: "Sunrise",
              value: "${DateFormat.Hm().format(sunriseTime)}",
            ),
            InfoCard(
              title: "Sunset",
              value: "${DateFormat.Hm().format(sunsetTime)}",
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
    );
  }

}
