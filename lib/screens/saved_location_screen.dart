import 'package:flutter/material.dart';
import 'package:flutter_weather/constants.dart';
import 'package:flutter_weather/screens/search_screen.dart';
import 'package:flutter_weather/screens/weather_screen.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_weather/database/database.dart';
import 'package:flutter_weather/database/saved_location.dart';

import 'package:flutter_weather/services/weather_receiver.dart';

class SavedLocationScreen extends StatefulWidget {
  @override
  _SavedLocationScreenState createState() => _SavedLocationScreenState();
}

class _SavedLocationScreenState extends State<SavedLocationScreen> {
  DatabaseHelper databaseHelper;
  List<SavedLocation> locations = new List();
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    initialiseDatabase();
  }

  Future<void> initialiseDatabase() async {
    databaseHelper = new DatabaseHelper();
    await databaseHelper.initialiseDatabase();
    refresh();
  }

  void refresh() async {
    locations = await databaseHelper.getLocations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Saved Locations"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var locationData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
          //check if returned data != null
          if (locationData != null) {
            MapBoxPlace place = locationData;
            double latitude = place.geometry.coordinates[1];
            double longitude = place.geometry.coordinates[0];
            String name = place.text;

            print("$name: $latitude, $longitude");

            await databaseHelper.insertLocation(SavedLocation(
                id: place.hashCode,
                title: name,
                latitude: latitude,
                longitude: longitude));
            refresh();
          }
        },
        label: Text("ADD LOCATION"),
        icon: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          SavedLocation data = locations[index];

          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(data.id.toString()),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              title: Text(
                data.title,
                style: kSubheadingTextStyle,
                overflow: TextOverflow.fade,
              ),
              subtitle: Text(
                data.getCoordinates(),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                var weatherData = await WeatherModel()
                    .getCoordLocationWeather(data.latitude, data.longitude);
                if (weatherData != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return WeatherScreen(
                        weather: weatherData,
                        title: data.title,
                      );
                    }),
                  );
                }
              },
            ),
            onDismissed: (direction) async {
              await databaseHelper.removeLocation(data.id);
              refresh();
            },
          );
        },
      ),
    );
  }
}
