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
    try {
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      //if the position is null, set location to null island
      latitude = position.latitude ?? 0;
      longitude = position.longitude ?? 0;
    } catch (e) {
      print(e);
    }
  }

}