import 'dart:ui';
import 'package:flutter_weather/animation/weather_type.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/animation/weather_animation.dart';
import 'package:flutter_weather/components/info_card.dart';
import 'package:flutter_weather/services/location_service.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:flutter_weather/components/panel_card.dart';
import 'package:flutter_weather/components/hourly_card.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_weather/services/extensions.dart';
import 'home_screen.dart';

class CurrentWeatherScreen extends StatefulWidget {
  //get the weather from loading screen
  @override
  CurrentWeatherScreen();
  _CurrentWeatherScreenState createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  //animation for the current time / weather

  WeatherAnimation weatherAnimation = new WeatherAnimation();

  double lat;
  double lon;

  DateTime weatherTime; //the time from the forecast
  DateTime sunriseTime; //sunrise
  DateTime sunsetTime; //sunset
  int timeZoneOffset;

  String conditionDescription;

  int temperature; //actual temperature, celsius for metric, fahrenheit for imperial
  double feelTemp; //what the temperature feels like (to one dp for accuracy)
  double uvIndex; //the UV index at midday
  int pressure;
  int humidity;

  double windSpeed; //wind speed in m/s for metric, mph for imperial
  String unitString; //unit for the wind speed
  int windDirection; //the angle of the wind direction in degrees

  List<dynamic> hourlyData;
  List<dynamic> dailyData;

  @override
  void initState() {
    super.initState();
    if (WeatherModel.weatherData != null) {
      updateUI();
    }
  }

  void updateUI() async {
    var weatherData = WeatherModel.weatherData;

    timeZoneOffset = WeatherModel.getSecondsTimezoneOffset();

    lat = weatherData["lat"].toDouble();
    lon = weatherData["lon"].toDouble();

    weatherTime = TimeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["dt"], timeZoneOffset);

    sunriseTime = TimeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["sunrise"].toInt(), timeZoneOffset);

    sunsetTime = TimeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["sunset"].toInt(), timeZoneOffset);

    int conditionCode = weatherData["current"]["weather"][0]["id"];
    //update all values
    temperature = weatherData["current"]["temp"]?.round();

    feelTemp = weatherData["current"]["feels_like"]?.toDouble();

    uvIndex = weatherData["current"]["uvi"]?.toDouble();

    humidity = weatherData["current"]["humidity"]?.round();

    pressure = weatherData["current"]["pressure"]?.round();


    windDirection = weatherData["current"]["wind_deg"]?.round();

    conditionDescription =
    weatherData["current"]["weather"][0]["description"];

    hourlyData = weatherData["hourly"];
    dailyData = weatherData["daily"];

    bool imperial = await SharedPrefs.getImperial();
    WindUnit unit = await SharedPrefs.getWindUnit();

    windSpeed =  WeatherModel.convertWindSpeed(weatherData["current"]["wind_speed"].round(), unit, imperial);
    unitString =  WeatherModel.getWindUnitString(unit);

    setState(() {
    });

    WeatherType weatherType = WeatherModel.getWeatherType(
        sunriseTime, sunsetTime, weatherTime, conditionCode);

    //if assets are not loaded yet, set the initial weather to build
    if (weatherAnimation.state == null) {
      weatherAnimation.initialWeather = weatherType;
      return;
    }
    //else set the weather normally
    weatherAnimation.state.weatherWorld.weatherType = weatherType;
  }

  //refresh data
  Future<void> refresh() async {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Refreshing...")));

    //if the location displayed is current, refresh location
    if (WeatherModel.locationName == "Current Location") {
      await WeatherModel.getUserLocationWeather();
    } else {
      //else refresh normally
      await WeatherModel.getCoordLocationWeather(
          lat, lon, WeatherModel.locationName);
    }

    updateUI();
    DateTime now = DateTime.now();
    String refreshTime = DateFormat.Hm().format(now);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Refreshed at $refreshTime")));
  }

  @override
  Widget build(BuildContext context) {
    if (WeatherModel.weatherData == null) {
      return Scaffold(
        backgroundColor: ThemeColors.backgroundColor(),
        body: Center(
          child: Text(
            "Choose a location to view weather.",
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
            color: Colors.white,
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          weatherAnimation,
          temperatureWidget(),
          //infoWidget(),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 85,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    //add a spacer
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                    ),
                    Column(
                      children: [
                        createHourlyForecastCard(),
                        createInfoCards(),
                      ],
                    ),
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
      top: 70,
      left: 5,
      child: SizedBox(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${temperature.toString()}°",
              style: kLargeTempTextStyle,
            ),
            Container(
              width: 300,
              padding: EdgeInsets.only(left: 5),
              child: Text(
                conditionDescription.toTitleCase(),
                textAlign: TextAlign.left,
                style: kConditionTextStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              child: Text(
                "Local Time ${DateFormat.Hm().format(weatherTime)} (UTC+${(timeZoneOffset / 3600).round()})",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.65), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoWidget() {
    return Positioned(
      top: 90,
      right: 5,
      child: Container(
        height: 100,
        width: 100,
        color: Colors.white,
      ),
    );
  }

  Widget createHourlyForecastCard() {
    return PanelCard(
      cardChild: Container(
        height: 200,
        width: double.infinity,
        margin: kPanelCardMargin,
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

              forecastTime = TimeHelper.getDateTimeSinceEpoch(
                  hourlyData[index]["dt"], timeZoneOffset);
              displayTime = "${forecastTime.hour.toString()}:00";

              DateTime tomorrowSunrise = TimeHelper.getDateTimeSinceEpoch(
                  dailyData[1]["sunrise"], timeZoneOffset);
              icon = WeatherModel.getIcon(hourlyData[index]["weather"][0]["id"],
                  forecastTime: forecastTime,
                  sunrise: sunriseTime,
                  sunset: sunsetTime,
                  tomorrowSunrise: tomorrowSunrise);
            }

            weatherData = hourlyData[index];

            int pop = (weatherData["pop"].toDouble() * 100)
                .round(); //probability of precipitation

            return HourlyCard(
              context: context,
              icon: icon,
              temp: temp,
              displayTime: displayTime,
              forecastTime: forecastTime,
              weatherData: weatherData,
              pop: pop,
              isCurrent: index == 0,
            );
          },
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 24,
        ),
      ),
    );
  }


  Widget createInfoCards() {


    return PanelCard(
      cardChild: Container(
        height: 225,
        width: double.infinity,
        margin: kPanelCardMargin,
        child: GridView.count(
          childAspectRatio: 2.5,
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
                  "${windSpeed.round().toString()} $unitString ${WeatherModel.getWindCompassDirection(windDirection)}",
            ),
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
