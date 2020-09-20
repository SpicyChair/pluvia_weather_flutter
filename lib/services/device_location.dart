import 'package:geolocator/geolocator.dart';

class Location {

  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await getCurrentPosition();
      //if the position is null, set location to null island
      latitude = position.latitude ?? 0;
      longitude = position.longitude ?? 0;
    } catch (e) {
      print(e);
    }
  }
}