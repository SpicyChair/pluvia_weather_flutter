import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/app_theme.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/screens/advanced_settings_screen.dart';
import 'package:flutter_weather/screens/changelog_screen.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

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
  bool use24;
  String windDropdownValue;
  String langDropdownValue;
  String thememodeDropdownValue;

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
    use24 = await SharedPrefs.get24();


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

    switch (await SharedPrefs.getThemeMode()) {
      case ThemeModePref.AUTO:
        thememodeDropdownValue = "Auto";
        break;
      case ThemeModePref.LIGHT:
        thememodeDropdownValue = "Light";
        break;
      case ThemeModePref.DARK:
        thememodeDropdownValue = "Dark";
        break;
    }
    langDropdownValue = await SharedPrefs.getLanguageCode();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          Language.getTranslation("more"),
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 30,
            color: Theme.of(context).primaryColorLight,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                      top: 20,
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
                      top: 60,
                      left: 16,
                      child: Text(
                        "v$version",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 16,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(right: 10),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChangelogScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "${Language.getTranslation("changelog")} >",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[400]),
                        ),
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
                    child: ListTile(
                      title: Text(
                        Language.getTranslation("darkMode"),
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                      ),
                      leading: Icon(
                        Icons.light_mode_outlined,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      trailing: DropdownButton<String>(
                        value: thememodeDropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        dropdownColor: Theme.of(context).backgroundColor,
                        onChanged: (String newValue) async {
                          thememodeDropdownValue = newValue;
                          switch (newValue) {
                            case "Auto":
                              Provider.of<AppThemeChangeNotifier>(context, listen: false).setThemeMode(ThemeModePref.AUTO);
                              await SharedPrefs.setThemeMode(ThemeModePref.AUTO);
                              break;
                            case "Light":
                              Provider.of<AppThemeChangeNotifier>(context, listen: false).setThemeMode(ThemeModePref.LIGHT);
                              await SharedPrefs.setThemeMode(ThemeModePref.LIGHT);
                              break;
                            case "Dark":
                              Provider.of<AppThemeChangeNotifier>(context, listen: false).setThemeMode(ThemeModePref.DARK);
                              await SharedPrefs.setThemeMode(ThemeModePref.DARK);
                              break;
                          }
                          setState(() {});
                        },
                        items: <String>["Auto", "Light", "Dark"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  color: Theme.of(context).cardColor,
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
                          color: Theme.of(context).primaryColorLight,
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
                      activeColor: Colors.blueAccent,
                      secondary: Icon(
                        Icons.thermostat_outlined,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: SwitchListTile(
                      title: Text(
                        Language.getTranslation("use24HourTime"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      value: use24 ?? false,
                      onChanged: (bool value) async {
                        await SharedPrefs.set24(value);
                        use24 = value;
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text(Language.getTranslation("refreshToSee"))));
                      },
                      activeColor: Colors.blueAccent,
                      secondary: Icon(
                        Icons.timelapse_outlined,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  color: Theme.of(context).cardColor,
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
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                      ),
                      leading: Icon(
                        Icons.waves_sharp,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      trailing: DropdownButton<String>(
                        value: windDropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        dropdownColor: Theme.of(context).backgroundColor,
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
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        Language.getTranslation("appLanguage"),
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                      ),
                      leading: Icon(
                        Icons.translate,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      trailing: DropdownButton<String>(
                        value: langDropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        dropdownColor: Theme.of(context).backgroundColor,
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
                                "$value (${Language.getLangString(value)}) "),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        Language.getTranslation("advancedSettings"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
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
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                  color: Theme.of(context).cardColor,
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
                      child: Theme.of(context).brightness == Brightness.dark
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
                            color: Theme.of(context).primaryColorLight),
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
