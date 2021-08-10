import 'package:flutter/material.dart';
import 'package:flutter_weather/components/API_textfield.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  @override
  _AdvancedSettingsScreenState createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  String version;

  final TextEditingController weatherKeyTextController =
      TextEditingController();
  final TextEditingController searchKeyTextController = TextEditingController();

  void initState() {
    super.initState();
    getVersion();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: ThemeColors.isDark  ? Brightness.dark : Brightness.light,
        title: Text("Advanced Settings"),//Language.getTranslation("advancedSettings")
        centerTitle: true,
        backgroundColor: ThemeColors.backgroundColor(),
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [
              /*
              SizedBox(
                height: 80,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                  color: ThemeColors.cardColor(),
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                      title: Text(
                        "Default Location", //TODO:Translate strings
                        //Language.getTranslation("defaultLocation")
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                      subtitle: Text("Use a default location instead of checking current location.", style: TextStyle(color: ThemeColors.secondaryTextColor()),),
                    ),
                  ),
                ),
              ),
              
               */
              Card(
                shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                color: ThemeColors.cardColor(),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.app_settings_alt_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                      title: Text(
                        "Custom API keys", //TODO:Translate strings
                        //Language.getTranslation("customKey")
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: APITextField(
                        hintText: "Enter OpenWeatherAPI Key", //Language.getTranslation("owmKey")
                        onChanged: (String text) async {
                          await SharedPrefs.setOpenWeatherAPIKey(text);
                        }, //TODO: edit a sharedpref onchanged
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: APITextField(
                        hintText: "Enter MapBox API Key",//Language.getTranslation("mbKey")
                        onChanged: (String text) async {
                          await SharedPrefs.setMapBoxAPIKey(text);
                        },
                      ),
                    ),
                    //SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          "Leave blank to use default values.\nIf API Keys are incorrect, default values will be used.",//Language.getTranslation("customKeyText")
                          style: TextStyle(
                            color: ThemeColors.secondaryTextColor()
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        Language.getTranslation("aboutPluvia"),
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationVersion: version,
                          applicationLegalese:
                              "Pluvia Weather is completely free and open source, and is licensed under GPLv3.",
                        );
                      },
                      leading: Icon(
                        Icons.more_horiz_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                  color: ThemeColors.cardColor(),
                ),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    "Thank you for using Pluvia Weather.",
                    style: TextStyle(color: ThemeColors.secondaryTextColor()),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
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
 */