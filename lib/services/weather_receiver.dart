import 'package:flutter_weather/services/api_keys.dart';
import 'networking.dart';
import 'device_location.dart';

const String kOpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/onecall?";


const String kUnit = "metric";

class WeatherModel {

  //get weather by user's current location
  Future<dynamic> getUserLocationWeather() async {

    //get the user's location
    Location location = Location();
    await location.getCurrentLocation();

    //send a request to OpenWeatherMap one call api
    NetworkHelper networkHelper = NetworkHelper(
      url:
      "${kOpenWeatherMapURL}lat=${location.latitude}&lon=${location.longitude}&exclude=minutely&appid=$kOpenWeatherApiKey&units=$kUnit",
    );
    print("${kOpenWeatherMapURL}lat=${location.latitude}&lon=${location.longitude}&exclude=minutely&appid=$kOpenWeatherApiKey&units=$kUnit");

    var weatherData = await networkHelper.getData(); //getData gets and decodes the json data

    return weatherData;
  }

  //get weather by latitude and longitude
  Future<dynamic> getCoordLocationWeather(double latitude, double longitude) async {

    //send a request to OpenWeatherMap one call api
    NetworkHelper networkHelper = NetworkHelper(
      url:
      "${kOpenWeatherMapURL}lat=$latitude&lon=$longitude&appid=$kOpenWeatherApiKey&units=$kUnit",
    );

    var weatherData = await networkHelper.getData(); //getData gets and decodes the json data

    return weatherData;
  }



}

