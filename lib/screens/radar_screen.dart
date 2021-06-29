import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
    return WebviewScaffold(
      hidden: true,
      initialChild: Container(
        height: double.infinity,
        width: double.infinity,
        color: ThemeColors.backgroundColor(),
        child: Center(
          child: SpinKitFadingCircle(
              color: ThemeColors.secondaryTextColor(), size: 50),
        ),
      ),
      url:
          "https://openweathermap.org/weathermap?basemap=map&cities=false&layer=radar&lat=$latitude&lon=$longitude&zoom=5",
      appBar: AppBar(
        title: Text(
          Language.getTranslation("weatherRadar"),
          style: TextStyle(color: ThemeColors.primaryTextColor()),
        ),
        centerTitle: true,
        backgroundColor: ThemeColors.backgroundColor(),
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
    );
  }
}

/*

 */
