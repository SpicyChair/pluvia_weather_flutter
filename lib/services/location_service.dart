import 'package:flutter_weather/services/api_keys.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart';


class LocationService {

  static double latitude;
  static double longitude;

  Future<void> requestLocationPermission() async {
    return await requestPermission();
  }

  static Future<void> getCurrentLocation() async {
    latitude = null;
    longitude = null;
    try {
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      //if the position is null, set location to null island
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

}