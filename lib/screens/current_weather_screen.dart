import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/animation/weather_type.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/radar_screen.dart';
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
  String timeZoneOffsetText; //the displayed version of timezoneoffset

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

  String refreshTime; //the time weather last updated

  bool isLoading = true; //if data is being loaded

  @override
  void initState() {
    super.initState();
    if (WeatherModel.weatherData != null) {
      updateUI();
    }
  }

  void updateUI() async {
    var weatherData = WeatherModel.weatherData;
    hourlyData = weatherData["hourly"];
    dailyData = weatherData["daily"];

    timeZoneOffset = WeatherModel.getSecondsTimezoneOffset();
    timeZoneOffsetText = timeZoneOffset.isNegative
        ? "${(timeZoneOffset / 3600).round()}"
        : "+${(timeZoneOffset / 3600).round()}"; //TODO: FIX ROUNDING OF TIMEZONE

    lat = weatherData["lat"].toDouble();
    lon = weatherData["lon"].toDouble();

    weatherTime = TimeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["dt"], timeZoneOffset);

    sunriseTime = TimeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["sunrise"].toInt(), timeZoneOffset);

    sunsetTime = TimeHelper.getDateTimeSinceEpoch(
        weatherData["current"]["sunset"].toInt(), timeZoneOffset);
    DateTime tomorrowSunrise = TimeHelper.getDateTimeSinceEpoch(
        dailyData[1]["sunrise"], timeZoneOffset);

    int conditionCode = weatherData["current"]["weather"][0]["id"];
    //update all values
    temperature = weatherData["current"]["temp"]?.round();
    feelTemp = weatherData["current"]["feels_like"]?.toDouble();
    uvIndex = weatherData["current"]["uvi"]?.toDouble();
    humidity = weatherData["current"]["humidity"]?.round();
    pressure = weatherData["current"]["pressure"]?.round();

    windDirection = weatherData["current"]["wind_deg"]?.round();

    conditionDescription = weatherData["current"]["weather"][0]["description"];

    bool imperial = await SharedPrefs.getImperial();
    WindUnit unit = await SharedPrefs.getWindUnit();

    windSpeed = WeatherModel.convertWindSpeed(
        weatherData["current"]["wind_speed"].round(), unit, imperial);
    unitString = WeatherModel.getWindUnitString(unit);

    WeatherType weatherType = WeatherModel.getWeatherType(
        sunriseTime, sunsetTime, tomorrowSunrise, weatherTime, conditionCode);

    //if assets are not loaded yet, set the initial weather to build
    if (weatherAnimation.state == null) {
      weatherAnimation.initialWeather = weatherType;
    } else {
      //else set the weather normally
      weatherAnimation.state.weatherWorld.weatherType = weatherType;
    }

    refreshTime = TimeHelper.getReadableTime(DateTime.now());

    setState(() {
      isLoading = false;
    });
  }

  //refresh data
  Future<void> refresh() async {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("${Language.getTranslation("loading")}...")));

    //if the location displayed is current, refresh location
    if (WeatherModel.locationName == Language.getTranslation("currentLocationTitle")) {
      await WeatherModel.getUserLocationWeather();
    } else {
      //else refresh normally
      await WeatherModel.getCoordLocationWeather(latitude: lat, longitude: lon, name: WeatherModel.locationName);
          //lati, lon, WeatherModel.locationName);
    }

    updateUI();

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("${Language.getTranslation("lastUpdatedAt")}$refreshTime")));
  }

  @override
  Widget build(BuildContext context) {
    if (WeatherModel.weatherData == null) {
      return Scaffold(
        backgroundColor: ThemeColors.backgroundColor(),
        body: Center(
          child: Text(
            Language.getTranslation("chooseLocationToView"),
            style: TextStyle(
              color: ThemeColors.primaryTextColor(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
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
      backgroundColor: ThemeColors.backgroundColor(),
      extendBodyBehindAppBar: true,
      body: isLoading
          ?
          //if is loading
          Center(
              child: Column(
              children: [
                SpinKitFadingCircle(
                  color: ThemeColors.secondaryTextColor(),
                  size: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  Language.getTranslation("loading"),
                  style: TextStyle(color: ThemeColors.secondaryTextColor()),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
          :

          //if loaded
          Stack(
              alignment: Alignment.topCenter,
              children: [
                weatherAnimation,
                temperatureWidget(),
                //infoWidget(),
                Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Thank you for using Pluvia Weather.",
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                      ),
                    ),
                ),
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
                              radarInfoCards(),

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
                "${Language.getTranslation("localTime")}${TimeHelper.getReadableTime(weatherTime)} (UTC$timeZoneOffsetText)",
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
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor(),
      ),
      child: Container(
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
              displayTime = TimeHelper.getShortReadableTime(forecastTime);

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

        width: double.infinity,
        margin: kPanelCardMargin,
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 2.5,
          crossAxisCount: 2,
          physics: NeverScrollableScrollPhysics(),
          children: [
            InfoCard(
              title: Language.getTranslation("feelsLike"),
              value: "${feelTemp.toString()}°",
            ),
            InfoCard(
              title: Language.getTranslation("wind"),
              value:
                  "${windSpeed.round().toString()} $unitString ${WeatherModel.getWindCompassDirection(windDirection)}",
            ),
            InfoCard(
              title: Language.getTranslation("sunrise"),
              value: "${TimeHelper.getReadableTime(sunriseTime)}",
            ),
            InfoCard(
              title: Language.getTranslation("sunset"),
              value: "${TimeHelper.getReadableTime(sunsetTime)}",
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
    );
  }

  Widget radarInfoCards() {

    return PanelCard(
      cardChild: Container(
        height: 140,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Card(
                child: Center(
                  child: ListTile(
                    title: Text(
                      Language.getTranslation("weatherRadar"),
                      style: TextStyle(
                        color: ThemeColors.primaryTextColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(50, 70),
                      ),
                      onPressed: () {
                        showDialog(

                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                              backgroundColor: ThemeColors.cardColor(),
                              insetPadding: EdgeInsets.all(20),
                              title: Center(
                                child: Text(
                                  Language.getTranslation("weatherRadarAboutTitle"),
                                  style: TextStyle(
                                    color: ThemeColors.primaryTextColor(),
                                  ),
                                ),
                              ),
                              content: Container(
                                width: 300,
                                height: 160,
                                child: Text(
                                    Language.getTranslation("weatherRadarAboutBody"),
                                style: TextStyle(
                                  color: ThemeColors.primaryTextColor()
                                ),),
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(Language.getTranslation("close"), style: TextStyle(color: ThemeColors.secondaryTextColor()),),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                    onTap: () {
                      //print("Pressed");
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RadarScreen(lat, lon);
                      },),);
                    },
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                color: ThemeColors.cardColor(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${Language.getTranslation("lastUpdatedAt")}$refreshTime",
                style: TextStyle(
                  color: ThemeColors.primaryTextColor(),
                ),),
            SizedBox(height: 5,),
            Text("($lat, $lon)",
              style: TextStyle(
                color: ThemeColors.primaryTextColor(),
              ),),
          ],
        ),
      ),
    );
  }
}

