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
    //return string representation of coord
    //rounded to 4 d.p. for display
    return "${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}";
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  String toString() => title;

}