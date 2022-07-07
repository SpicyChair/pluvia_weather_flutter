import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class RadarScreen extends StatelessWidget {
  double latitude;
  double longitude;

  RadarScreen(latitude, longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }
//'https://openweathermap.org/weathermap?basemap=map&cities=false&layer=radar&lat=$latitude&lon=$longitude&zoom=6',
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.getTranslation("weatherRadar"),
          style: TextStyle(
            color: ThemeColors.primaryTextColor(),
          ),
        ),
        backgroundColor: ThemeColors.backgroundColor(),
        centerTitle: true,
        leading: TextButton(
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.primaryTextColor(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebView(
          initialUrl:
              'https://openweathermap.org/weathermap?basemap=map&cities=false&layer=radar&lat=$latitude&lon=$longitude&zoom=5'),
    );
  }
}
