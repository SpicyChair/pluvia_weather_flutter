import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/loading_screen.dart';

import 'advanced_settings_screen.dart';

class DisclaimerScreen extends StatefulWidget {
  @override
  _DisclaimerScreenState createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer", style: TextStyle(color: ThemeColors.primaryTextColor()),),
        centerTitle: true,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("It is recommended that you use your own OpenWeather API key."),
          SizedBox(
            height: 80,
            child: Card(
              child: Center(
                child: ListTile(
                  title: Text(
                    Language.getTranslation("advancedSettings"),
                    style: TextStyle(
                      color: ThemeColors.primaryTextColor(),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdvancedSettingsScreen()));
                  },
                  leading: Icon(
                    Icons.settings,
                    color: ThemeColors.secondaryTextColor(),
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
              color: ThemeColors.cardColor(),
            ),
          ),
          Text("Please enter 'Advanced Settings' and add your key if you do not have one already."),

          FlatButton(onPressed: () async {
            MaterialPageRoute(builder: (context) => LoadingScreen());
          }, child: Text(Language.getTranslation("close")))
        ],
      ),
    );
  }
}
