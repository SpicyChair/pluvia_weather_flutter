import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/advanced_settings_screen.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';

import 'loading_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String version;

  //the values displayed on the toggles
  bool useImperial;
  bool useDarkMode;
  String windDropdownValue;
  String langDropdownValue;

  void initState() {
    super.initState();
    getVersion();
    getSharedPrefs();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  //gets the shared prefs to display on the toggles
  Future<void> getSharedPrefs() async {
    useImperial = await SharedPrefs.getImperial();
    useDarkMode = await SharedPrefs.getDark();
    switch (await SharedPrefs.getWindUnit()) {
      case WindUnit.MS:
        windDropdownValue = "meters/s";
        break;
      case WindUnit.MPH:
        windDropdownValue = "miles/h";
        break;
      case WindUnit.KMPH:
        windDropdownValue = "kilometers/h";
        break;
    }
    langDropdownValue = await SharedPrefs.getLanguageCode();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(),
      appBar: AppBar(
        brightness: ThemeColors.isDark ? Brightness.dark : Brightness.light,
        title: Text(
          Language.getTranslation("more"),
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 30,
            color: ThemeColors.primaryTextColor(),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                height: 125,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: kBorderRadius,
                  color: Colors.grey[900],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 25,
                      left: 15,
                      child: Text(
                        "Pluvia Weather",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 35,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 16,
                      child: Text(
                        "Version $version",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 22,
                      right: 15,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/pluvia.png"),
                            fit: BoxFit.fill,
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
                    child: SwitchListTile(
                      title: Text(
                        Language.getTranslation("darkMode"),
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                      ),
                      value: useDarkMode ?? false,
                      onChanged: (bool value) async {
                        useDarkMode = true;
                        ThemeColors.switchTheme(value);
                        //restart the app to show theme changes
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HomeScreen();
                            },
                          ),
                        );
                      },
                      secondary: Icon(
                        Icons.lightbulb_outline,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: SwitchListTile(
                      title: Text(
                        Language.getTranslation("useFahrenheit"),
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                      value: useImperial ?? false,
                      onChanged: (bool value) async {
                        await SharedPrefs.setImperial(value);
                        useImperial = value;
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text(Language.getTranslation("refreshToSee"))));
                      },
                      secondary: Icon(
                        Icons.thermostat_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        Language.getTranslation("windSpeedUnit"),
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                      ),
                      leading: Icon(
                        Icons.waves_sharp,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                      trailing: DropdownButton<String>(
                        value: windDropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        style: TextStyle(
                            color: ThemeColors.primaryTextColor(),
                            fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        dropdownColor: ThemeColors.backgroundColor(),
                        onChanged: (String newValue) async {
                          windDropdownValue = newValue;
                          switch (newValue) {
                            case "miles/h":
                              await SharedPrefs.setWindUnit(WindUnit.MPH);
                              break;
                            case "meters/s":
                              await SharedPrefs.setWindUnit(WindUnit.MS);
                              break;
                            case "kilometers/h":
                              await SharedPrefs.setWindUnit(WindUnit.KMPH);
                              break;
                          }
                          setState(() {});
                        },
                        items: <String>["miles/h", "meters/s", "kilometers/h"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        "App Language",
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                      ),
                      leading: Icon(
                        Icons.translate,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                      trailing: DropdownButton<String>(
                        value: langDropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        style: TextStyle(
                            color: ThemeColors.primaryTextColor(),
                            fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        dropdownColor: ThemeColors.backgroundColor(),
                        onChanged: (String newValue) async {
                          langDropdownValue = newValue;
                          await SharedPrefs.setLanguageCode(newValue);

                          await Language.initialise();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingScreen()));
                          //restart the app to get forecast in new language
                          //Restart.restartApp();
                        },
                        items: Language.langaugeCodes()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                                "${Language.getLangString(value)} ($value)"),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        //TODO: TRANSLATE
                        "Advanced Settings",
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
              SizedBox(
                height: 12,
              ),
              Container(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () async {
                        const url =
                            "https://github.com/SpicyChair/pluvia_weather_flutter";
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: ThemeColors.isDark
                          ? Image.asset("assets/GitHub-Mark-Light-64px.png")
                          : Image.asset("assets/GitHub-Mark-64px.png"),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text(
                        Language.getTranslation("viewOnGithub"),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.primaryTextColor()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
