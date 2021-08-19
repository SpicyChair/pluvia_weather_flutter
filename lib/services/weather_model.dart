import 'package:connectivity/connectivity.dart';
import 'package:flutter_weather/animation/weather_type.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
//import 'package:flutter_weather/api_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'networking.dart';
import 'location_service.dart';
import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String kOpenWeatherMapURL =
    "https://api.openweathermap.org/data/2.5/onecall?";

class WeatherModel {
  /*
  Holds the weather data in use
   */
  static var weatherData;
  static String locationName;
  static String unit;
  static var _kOpenWeatherApiKey = env["OPENWEATHER_API_KEY"];
  static var _kOpenWeatherApiKeyCustom;

  static Future<void> initialize() async {
    bool useImperial = await SharedPrefs.getImperial();
    unit = useImperial ? "imperial" : "metric";

    _kOpenWeatherApiKeyCustom = await SharedPrefs.getOpenWeatherAPIKey();
  }

  /*
  Gets weather from user location
   */
  static Future<int> getUserLocationWeather() async {
    initialize();

    if (await (Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      //return a code to show that connection failed
      return 0;
    }
    //get the user's location
    //await LocationService.requestLocationPermission();
    await LocationService.getCurrentLocation();

    //send a request to OpenWeatherMap one call api

    if (_kOpenWeatherApiKeyCustom != "") {
      NetworkHelper networkHelper = NetworkHelper(
        url:
        "${kOpenWeatherMapURL}lat=${LocationService
            .latitude}&lon=${LocationService
            .longitude}&appid=$_kOpenWeatherApiKeyCustom&units=$unit&lang=${Language
            .getCurrentCode()}",
      );
      print(
          "${kOpenWeatherMapURL}lat=${LocationService
              .latitude}&lon=${LocationService
              .longitude}&appid=$_kOpenWeatherApiKeyCustom&units=$unit&lang=${Language
              .getCurrentCode()}");
      weatherData = await networkHelper
          .getData(); //getData gets and decodes the json data
      locationName = Language.getTranslation("currentLocationTitle");

      if (weatherData != null) {
        return 1;
      }
    }

      NetworkHelper networkHelper = NetworkHelper(
        url:
            "${kOpenWeatherMapURL}lat=${LocationService.latitude}&lon=${LocationService.longitude}&appid=$_kOpenWeatherApiKey&units=$unit&lang=${Language.getCurrentCode()}",
      );
      print(
          "${kOpenWeatherMapURL}lat=${LocationService.latitude}&lon=${LocationService.longitude}&appid=$_kOpenWeatherApiKey&units=$unit&lang=${Language.getCurrentCode()}");
      weatherData = await networkHelper
          .getData(); //getData gets and decodes the json data
      locationName = Language.getTranslation("currentLocationTitle");
    return 1;
  }

  /*
  Gets weather from latitude and longitude
   */

  static Future<int> getCoordLocationWeather(
  {double latitude, double longitude, String name}) async {
    initialize();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //return it to the loading screen
      return 0;
    }

    //send a request to OpenWeatherMap one call api

    NetworkHelper networkHelper = NetworkHelper(
      url:
          "${kOpenWeatherMapURL}lat=$latitude&lon=$longitude&appid=$_kOpenWeatherApiKey&units=$unit&lang=${Language.getCurrentCode()}",
    );
    var data =
        await networkHelper.getData(); //getData gets and decodes the json data

    //force weather screens to display error message when location disabled
    //this fixes bug present in < 1.0.7
    if (latitude == null && longitude == null) {
      data = null;
    }

    weatherData = data;
    locationName = name;

    return 1;
  }

  /*
  Methods for processing weather data

   */

  static String getIcon(int id,
      {DateTime forecastTime,
      DateTime sunset,
      DateTime sunrise,
      DateTime tomorrowSunrise}) {
    bool isNight;
    //check if time is between sunrise and sunset, or before sunrise
    if (forecastTime != null) {
      //however if only the id is given, night is false (always get day icon)
      isNight =
          (forecastTime.isAfter(sunset) || forecastTime.isBefore(sunrise)) &&
              forecastTime.isBefore(tomorrowSunrise);
    } else {
      isNight = false;
    }

    if (id < 300) {
      //thunderstorms
      if (id <= 202 || id >= 230) {
        //thunderstorms with rain
        return _getEmoji("Thunder Cloud and Rain");
      } else {
        return _getEmoji("Cloud with Lightning");
      }
    } else if (id < 600) {
      // rain / drizzle
      //return "🌧️";
      return _getEmoji("Cloud with Rain");
    } else if (id < 700) {
      //snow
      //return "❄";
      return _getEmoji("Snowflake");
    } else if (id < 800) {
      //atmosphere
      //return "🌫️";
      return _getEmoji("Fog");
    } else if (id == 800) {
      //clear
      //return isNight ? "🌘" : "☀";
      return isNight ? _getEmoji("Waning Crescent Moon") : _getEmoji("Sun");
    } else if (id == 801) {
      // partly cloudy
      //return isNight ? "🌘" : "⛅";
      return isNight
          ? _getEmoji("Waning Crescent Moon")
          : _getEmoji("Sun Behind Cloud");
    } else if (id == 802) {
      //a bit cloudier than partly cloudy

      //return isNight ? "🌘" : "🌥️";
      return isNight
          ? _getEmoji("Waning Crescent Moon")
          : _getEmoji("Sun Behind Large Cloud");
    } else {
      //cloudy
      return "☁";
    }
  }

  static String _getEmoji(String name) {
    //print(Emoji.byName(name).char);
    return Emoji.byName(name).char;
  }

  static String getWindCompassDirection(int angle) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[((angle / 45) % 8).floor()];
  }

  static WeatherType getWeatherType(DateTime sunrise, DateTime sunset,
      DateTime tomorrowSunrise, DateTime forecastTime, int conditionCode) {
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

      if ((forecastTime.isAfter(sunset.add(Duration(minutes: 120))) ||
              forecastTime.isBefore(sunrise)) &&
          forecastTime
              .isBefore(tomorrowSunrise.subtract(Duration(minutes: 30)))) {
        //night
        weatherType = WeatherType.clearNight;
      } else if (forecastTime.isAfter(sunset) &&
          forecastTime.isBefore(sunset.add(Duration(minutes: 120)))) {
        //sunset
        weatherType = WeatherType.clearEvening;
      } else if (forecastTime.hour >= 12 && forecastTime.isBefore(sunset)) {
        weatherType = WeatherType.clearAfternoon;
      } else if (forecastTime.isAfter(sunrise.add(Duration(minutes: 30)))) {
        weatherType = WeatherType.clearDay;
      } else {
        weatherType = WeatherType.sunrise;
      }
    }
    return weatherType;
  }

  static int getSecondsTimezoneOffset() {
    return weatherData["timezone_offset"];
  }

  static double convertWindSpeed(int speed, WindUnit unit, bool imperial) {
    if (imperial) {
      //if imperial units used
      //convert from mph to other units
      switch (unit) {
        case WindUnit.KMPH:
          return speed * 1.609;
        case WindUnit.MS:
          return speed / 2.237;
        case WindUnit.MPH:
          return speed.toDouble();
        default:
          return 0;
      }
    } else {
      //if metric units used
      //convert from m/s to other units
      switch (unit) {
        case WindUnit.KMPH:
          return speed * 3.6;
        case WindUnit.MS:
          return speed.toDouble();
        case WindUnit.MPH:
          return speed * 2.237;
        default:
          return 0;
      }
    }
  }

  static String getWindUnitString(WindUnit unit) {
    switch (unit) {
      case WindUnit.MS:
        return "m/s";
      case WindUnit.MPH:
        return "mph";
      case WindUnit.KMPH:
        return "km/h";
    }
  }
}
