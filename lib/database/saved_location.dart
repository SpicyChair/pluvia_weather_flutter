class SavedLocation {
  int id;
  String title;
  double latitude;
  double longitude;

  SavedLocation({
    this.latitude,
    this.longitude,
    this.title,
    this.id,
  });

  String getCoordinates() {
    return "$latitude, $longitude";
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}