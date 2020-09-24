import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/screens/loading_screen.dart';
import 'package:flutter_weather/screens/search_screen.dart';
import 'package:flutter_weather/screens/current_weather_screen.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_weather/database/database.dart';
import 'package:flutter_weather/database/saved_location.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_weather/services/weather_receiver.dart';

class SavedLocationScreen extends StatefulWidget {
  final bool
      locationDisabledInitially; //if location permissions were disabled on app open

  SavedLocationScreen({this.locationDisabledInitially});
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
    Future.delayed(Duration.zero, () {
      if (widget.locationDisabledInitially) {
        showLocationPrompt();
      }
    });
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: widget.locationDisabledInitially,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                color: Colors.blueAccent,
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                //bring the user back to the loading screen where location is checked
                                LoadingScreen()));
                  },
                  borderRadius: kBorderRadius,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Device Location",
                            style: kSubheadingTextStyle.copyWith(
                                color: Colors.white)),
                        Text(
                          "View weather forecast for your current location",
                          style:
                              kSubtitleTextStyle.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Text(
              "Swipe Left or Right to Delete Location",
              style: TextStyle(color: Colors.black38),
            )),
          ),
          Expanded(
            child: ListView.builder(
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
                      style: kSubtitleTextStyle,
                    ),
                    onTap: () async {
                      var weatherData = await WeatherModel()
                          .getCoordLocationWeather(
                              data.latitude, data.longitude);
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
          ),
        ],
      ),
    );
  }

  /*








   */

  void showLocationPrompt() {
    //if location is disabled ask the user to open settings
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Disabled"),
          content: Text(
              "For Pluvia Weather to show weather in your current location, enable location."),
          actions: [
            FlatButton(
              child: Text("Open Location Settings"),
              onPressed: () {
                //open the settings screen for location
                AppSettings.openLocationSettings();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                //closes the dialog
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
