/*
This is the screen which acts as a
home screen to the other widgets

It contains a bottom navigation bar for navigating
between the screens
 */

import 'package:flutter/material.dart';
import 'package:flutter_weather/screens/loading_screen.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter_weather/screens/seven_day_forecast_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  List<Widget> _screens = [

    SevenDayForecastScreen(),
    SavedLocationScreen(),
    LoadingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 12,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 800),
              tabBackgroundColor: Colors.grey[800],
              tabs: [
                GButton(
                  icon: LineIcons.sun_o,
                  backgroundColor: Colors.redAccent.withOpacity(0.5),
                  text: "Current Weather",
                ),
                GButton(
                  icon: LineIcons.calendar,
                  text: "Next 7 Days",
                ),
                GButton(
                  icon: LineIcons.location_arrow,
                  text: "Saved Locations",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
