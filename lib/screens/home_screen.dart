import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/screens/current_weather_screen.dart';
import 'package:flutter_weather/screens/loading_screen.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter_weather/screens/daily_forecast_screen.dart';
import 'package:flutter_weather/screens/more_screen.dart';
import 'package:flutter_weather/services/location_service.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

/*
This is the screen which acts as a
home screen to the other widgets

It contains a bottom navigation bar for navigating
between the screens
 */

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  void initState() {
    super.initState();
    if (WeatherModel.weatherData == null) {
      Future.delayed(Duration.zero, () {
        showLocationPrompt();
      });
    }
  }

  int _selectedIndex = 0; //selected index of the bottom nav bar
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        controller: pageController,
        children: [
          CurrentWeatherScreen(),
          DailyForecastScreen(),
          SavedLocationScreen(
            onLocationSelect: onTabChange,
          ),
          MoreScreen(),
        ],
        onPageChanged: (index) {
          onPageChange(index);
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: GNav(
                curve: Curves.easeOutExpo,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 26,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 500),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: LineIcons.sun_o,
                    text: 'Current',
                    iconActiveColor: Colors.amber[900],
                    iconColor: Colors.black,
                    textColor: Colors.amber[900],
                    backgroundColor: Colors.amber[600].withOpacity(.2),
                  ),
                  GButton(
                    icon: LineIcons.calendar,
                    text: 'Forecast',
                    iconActiveColor: Colors.pink,
                    iconColor: Colors.black,
                    textColor: Colors.pink,
                    backgroundColor: Colors.pink.withOpacity(.2),
                  ),
                  GButton(
                    icon: LineIcons.location_arrow,
                    text: 'Locations',
                    iconActiveColor: Colors.blueAccent,
                    iconColor: Colors.black,
                    textColor: Colors.blueAccent,
                    backgroundColor: Colors.blueAccent.withOpacity(.2),
                  ),
                  GButton(
                    icon: Icons.more_vert_outlined,
                    text: 'More',
                    iconActiveColor: Colors.teal,
                    iconColor: Colors.black,
                    textColor: Colors.teal,
                    backgroundColor: Colors.teal.withOpacity(.2),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  onTabChange(index);
                }),
          ),
        ),
      ),
    );
  }

  void onPageChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

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
              child: Text("Retry"),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
              },
            ),
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
