import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
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
    super.initState();/*
    if (LocationService.longitude == null || LocationService.latitude == null) {
      Future.delayed(Duration.zero, () {
        showLocationPrompt();
        onTabChange(2); //go to location tab
      });
    } else*/
    if (WeatherModel.weatherData == null) {
      Future.delayed(Duration.zero, () {
        showLocationPrompt();
        onTabChange(2); //go to location tab
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
        decoration: BoxDecoration(
          color: ThemeColors.cardColor(),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.15)),
          ],
        ),
        height: 75,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: GNav(
                curve: Curves.easeOutExpo,
                gap: 5,
                activeColor: Colors.white,
                iconSize: 26,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 500),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: LineIcons.sun_o,
                    text: Language.getTranslation("current"),
                    iconActiveColor: Colors.amber[900],
                    iconColor: ThemeColors.primaryTextColor(),
                    textColor: Colors.amber[900],
                    backgroundColor: Colors.amber[600].withOpacity(.2),
                  ),
                  GButton(
                    icon: LineIcons.calendar,
                    text: Language.getTranslation("forecast"),
                    iconActiveColor: Colors.pink,
                    iconColor: ThemeColors.primaryTextColor(),
                    textColor: Colors.pink,
                    backgroundColor: Colors.pink.withOpacity(.2),
                  ),
                  GButton(
                    icon: Icons.location_on_outlined,
                    text: Language.getTranslation("locations"),
                    iconActiveColor: Colors.blueAccent,
                    iconColor: ThemeColors.primaryTextColor(),
                    textColor: Colors.blueAccent,
                    backgroundColor: Colors.blueAccent.withOpacity(.2),
                  ),
                  GButton(
                    icon: Icons.more_vert_outlined,
                    text: Language.getTranslation("more"),
                    iconActiveColor: Colors.teal,
                    iconColor: ThemeColors.primaryTextColor(),
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
          title: Text("Location Error"),
          content: Text(
            Language.getTranslation("locationDisabledPrompt"),),
          actions: [
            FlatButton(
              child: Text(Language.getTranslation("retry")),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoadingScreen()));
              },
            ),
            FlatButton(
              child: Text(Language.getTranslation("openLocationSettings")),
              onPressed: () {
                //open the settings screen for location
                AppSettings.openLocationSettings();
              },
            ),
            FlatButton(
              child: Text(Language.getTranslation("close")),
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

  void showNetworkPrompt() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Language.getTranslation("serverErrorTitle")),
            content: Text(
                Language.getTranslation("serverErrorBody")),
            actions: [
              FlatButton(
                child: Text(Language.getTranslation("retry")),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoadingScreen()));
                },
              ),
            ],
          );
        });
  }
}
