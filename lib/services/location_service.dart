import 'package:flutter_weather/api_keys.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:mapbox_search/mapbox_search.dart';
//import 'package:location/location.dart';


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


  /*
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    //Check if service is enabed

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    //Check for permissions

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();


    //update location
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;

    print("$latitude, $longitude");
    */
  }

}