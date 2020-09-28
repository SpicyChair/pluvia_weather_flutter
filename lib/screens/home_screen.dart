import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/screens/current_weather_screen.dart';
import 'package:flutter_weather/screens/loading_screen.dart';
import 'package:flutter_weather/screens/saved_location_screen.dart';
import 'package:flutter_weather/screens/daily_forecast_screen.dart';
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

  int _selectedIndex = 0; //selected index of the bottom nav bar
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: _selectedIndex != 2 ? AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text("Pluvia Weather", style: TextStyle(
          color: _selectedIndex == 0 ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w400
        ),),
      ) : PreferredSize(preferredSize: Size(0.0, 0.0),child: Container()),


       */

      extendBodyBehindAppBar: true,
      body: PageView(
        controller: pageController,
        children: [
          CurrentWeatherScreen(),
          DailyForecastScreen(),
          SavedLocationScreen(
            onLocationSelect: onTabChange,
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: GNav(
                curve: Curves.easeOutExpo,
                gap: 12,
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
}
