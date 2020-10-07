import 'package:connectivity/connectivity.dart';
import 'package:flutter_weather/animation/weather_type.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/services/api_keys.dart';
import 'file:///E:/flutter_weather/lib/preferences/shared_prefs.dart';
import 'networking.dart';
import 'location_service.dart';
import 'package:flutter/material.dart';

const String kOpenWeatherMapURL =
    "https://api.openweathermap.org/data/2.5/onecall?";

class WeatherModel {
  /*
  Holds the weather data in use
   */
  static var weatherData;
  static String locationName;
  static String unit;

  static Future<void> getUnit() async {
    bool useImperial = await SharedPrefs.getImperial();

    unit = useImperial ? "imperial" : "metric";
  }

  /*
  Gets weather from user location
   */
  static Future<int> getUserLocationWeather() async {
    getUnit();

    if (await (Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      //return a code to show that connection failed
      return 0;
    }
    //get the user's location
    LocationService location = LocationService();
    await location.getCurrentLocation();

    //send a request to OpenWeatherMap one call api
    NetworkHelper networkHelper = NetworkHelper(
      url:
          "${kOpenWeatherMapURL}lat=${location.latitude}&lon=${location.longitude}&appid=$kOpenWeatherApiKey&units=$unit",
    );
    print(
        "${kOpenWeatherMapURL}lat=${location.latitude}&lon=${location.longitude}&appid=$kOpenWeatherApiKey&units=$unit");

    weatherData =
        await networkHelper.getData(); //getData gets and decodes the json data
    locationName = "Current Location";

    return 1;
  }

  /*
  Gets weather from latitude and longitude
   */

  static Future<void> getCoordLocationWeather(
      double latitude, double longitude, String name) async {
    getUnit();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //return it to the loading screen
      return 0;
    }

    //send a request to OpenWeatherMap one call api
    NetworkHelper networkHelper = NetworkHelper(
      url:
          "${kOpenWeatherMapURL}lat=$latitude&lon=$longitude&appid=$kOpenWeatherApiKey&units=$unit",
    );

    var data =
        await networkHelper.getData(); //getData gets and decodes the json data

    weatherData = data;
    locationName = name;
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

  static String getWindCompassDirection(int angle) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[((angle / 45) % 8).floor()];
  }

  static WeatherType getWeatherType(DateTime sunrise, DateTime sunset,
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
    return weatherType;
  }

  static int getSecondsTimezoneOffset() {
    return weatherData["timezone_offset"];
  }
}
