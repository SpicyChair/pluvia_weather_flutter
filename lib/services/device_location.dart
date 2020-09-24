import 'package:geolocator/geolocator.dart';

class Location {

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
}