import 'package:flutter_weather/services/api_keys.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart';


class LocationService {

  double latitude;
  double longitude;

  Future<void> requestLocationPermission() async {
    return await requestPermission();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      //if the position is null, set location to null island
      latitude = position.latitude ?? 0;
      longitude = position.longitude ?? 0;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> locationEnabled() async {
    return await isLocationServiceEnabled();
  }
  Future<bool> locationPermissionEnabled() async {
    LocationPermission permission = await checkPermission();
    if ((permission == LocationPermission.deniedForever) || (permission == LocationPermission.denied)) {
      return false;
    }
    return true;
  }

  Future<String> getNameFromCoordinates(double latitude, double longitude) async {
    var reverseGeoCoding = ReverseGeoCoding(
      apiKey: kMapBoxApiKey,
      limit: 1,
    );

   List<MapBoxPlace> places = await reverseGeoCoding.getAddress(Location(lat: latitude, lng: longitude));
   return places[0].placeName;
  }
}