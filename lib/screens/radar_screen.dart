import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RadarScreen extends StatelessWidget {
  double latitude;
  double longitude;
  var controller;

  RadarScreen(latitude, longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://openweathermap.org/weathermap?basemap=map&cities=false&layer=radar&lat=$latitude&lon=$longitude&zoom=6'));
  }
//'https://openweathermap.org/weathermap?basemap=map&cities=false&layer=radar&lat=$latitude&lon=$longitude&zoom=6',
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.getTranslation("weatherRadar"),
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        leading: TextButton(
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColorLight,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebViewWidget(controller: this.controller,)
    );
  }
}
