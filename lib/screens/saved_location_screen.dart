import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/components/location_card.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
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
  List<SavedLocation> locations = [];
  var uuid = Uuid();
  var inkwellColor = null;

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
      appBar: AppBar(
        brightness: ThemeColors.isDark  ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Text(
          Language.getTranslation("locations"),
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 30,
            color: ThemeColors.primaryTextColor(),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            //bring the user back to the loading screen where location is checked
                            LoadingScreen()));
              },
              child: Icon(
                Icons.location_on_outlined,
                size: 27,
                color: ThemeColors.primaryTextColor(),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          /*
          Test Code
           await WeatherModel.getCoordLocationWeather(
          //               51.5074, 0.1278, "London");
          //           widget.onLocationSelect(0);
          //           return;
           */

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
        label: Text(Language.getTranslation("addLocation")),
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
                            LoadingScreen(),
                      ),
                    );
                  },
                  borderRadius: kBorderRadius,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(Language.getTranslation("currentLocationTitle"),
                            style: kSubheadingTextStyle.copyWith(
                                color: Colors.white)),
                        Text(
                          Language.getTranslation("tapToSeeWeatherCurrent"),
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
                  Language.getTranslation("pressAndHold"),
                  style: TextStyle(color: ThemeColors.secondaryTextColor()),
                ),
              ),
            ),
            Expanded(
              //child: ReorderableListView(
              // onReorder: reorderData)
              child: ListView(
                children: [
                  for (final data in locations)
                    LocationCard(
                      data: data,
                      onLocationSelect: widget.onLocationSelect,
                      refresh: refresh,
                      onLongPress: () async {
                        await databaseHelper.removeLocation(data.id);
                        refresh();
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reorderData(int oldIndex, int newIndex) async {
    //checks if data has been reordered
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      //"pop" the item index
      final i = locations.removeAt(oldIndex);

      locations.insert(newIndex, i);
    });

    print(locations);
  }
}



/*
onDismissed: (direction) async {
                      await databaseHelper.removeLocation(data.id);
                      refresh();
                    },



 child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  SavedLocation data = locations[index];
                  return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      title: Text(
                        data.title,
                        style: kSubheadingTextStyle.copyWith(
                            color: ThemeColors.primaryTextColor()),
                        overflow: TextOverflow.fade,
                      ),
                      subtitle: Text(
                        data.getCoordinates(),
                        style: kSubtitleTextStyle.copyWith(
                            color: ThemeColors.secondaryTextColor()),
                      ),
                      onTap: () async {
                        await WeatherModel.getCoordLocationWeather(
                            data.latitude, data.longitude, data.title);
                        widget.onLocationSelect(0);
                      },



                      trailing: TextButton(
                        onPressed: () {},
                        child: Icon(Icons.more_horiz),
                      ),

                  );
                },
              ),
 */
