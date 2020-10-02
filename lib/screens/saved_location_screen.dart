import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/screens/loading_screen.dart';
import 'package:flutter_weather/screens/search_screen.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_weather/database/database.dart';
import 'package:flutter_weather/database/saved_location.dart';
import 'package:app_settings/app_settings.dart';

class SavedLocationScreen extends StatefulWidget {

 // open  the weather page when location chosen
  final Function(int) onLocationSelect;

  SavedLocationScreen({this.onLocationSelect});
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
    /*
    Future.delayed(Duration.zero, () {
      if (widget.locationDisabledInitially) {
        showLocationPrompt();
      }
    });
    
     */
  }

  Future<void> initialiseDatabase() async {
    databaseHelper = new DatabaseHelper();
    await databaseHelper.initialiseDatabase();
    refresh();
  }

  void refresh() async {
    locations = await databaseHelper.getLocations();
    if (this.mounted) {
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                "< < < Swipe Left on Location to Delete < < <",
                style: TextStyle(color: Colors.black38),
              )),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  SavedLocation data = locations[index];

                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                    ),
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
                        await WeatherModel.getCoordLocationWeather(
                            data.latitude, data.longitude, data.title);
                        widget.onLocationSelect(0);
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
      ),
    );
  }
}
