import 'package:flutter/material.dart';
import 'package:flutter_weather/components/API_textfield.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
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
        title: Text("Advanced Settings"),
        centerTitle: true,
        backgroundColor: ThemeColors.backgroundColor(),
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: APITextField(
                        hintText: "Enter OpenWeatherAPI Key (Required)",
                        onChanged: (String text) {print(text);},
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: APITextField(
                        hintText: "Enter MapBox API Key (Option)",
                        onChanged: (String text) {print(text);},
                      ),
                    ),
                    SizedBox(height: 15,),
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
            ],
          ),
        ),
      ),
    );
  }
}
