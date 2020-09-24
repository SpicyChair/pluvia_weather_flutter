import 'package:connectivity/connectivity.dart';
import 'package:flutter_weather/services/api_keys.dart';
import 'networking.dart';
import 'device_location.dart';

const String kOpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/onecall?";


const String kUnit = "metric";

class WeatherModel {

  //get weather by user's current location
  Future<dynamic> getUserLocationWeather() async {
    
    await location.requestLocationPermission();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //return a code to show that connection failed
      return 0;
    }

    //get the user's location
    Location location = Location();
    await location.getCurrentLocation();
    if (!await location.locationEnabled() || !await location.locationPermissionEnabled()) {
      //no location enabled
      return 1;
    }


    //send a request to OpenWeatherMap one call api

    String fakeTestKey = "abc";
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

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //return a code to show that connection failed
      return 0;
    }

    //send a request to OpenWeatherMap one call api
    NetworkHelper networkHelper = NetworkHelper(
      url:
      "${kOpenWeatherMapURL}lat=$latitude&lon=$longitude&appid=$kOpenWeatherApiKey&units=$kUnit",
    );

    var weatherData = await networkHelper.getData(); //getData gets and decodes the json data

    return weatherData;
  }



}

