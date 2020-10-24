import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String version;

  //the values displayed on the toggles
  bool useImperial;
  bool useDarkMode;

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(),
      appBar: AppBar(
        title: Text(
          "More",
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
                        "Dark Mode",
                        style: TextStyle(
                            color: ThemeColors.primaryTextColor()),
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
                  shape:
                      RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: SwitchListTile(
                      title: Text(
                        "Use Imperial Units",
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                      value: useImperial ?? false,
                      onChanged: (bool value) async {
                        SharedPrefs.setImperial(value);
                        useImperial = value;
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Refresh forecast to see changes")));
                      },
                      secondary: Icon(
                        Icons.thermostat_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape:
                      RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),

              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text("Wind Speed Unit"),
                      onTap: () {
                      },
                      leading: Icon(Icons.toys_outlined, color: ThemeColors.secondaryTextColor(),),
                      trailing: Container(width: 50, height: 50, color: Colors.blueAccent,),
                    ),
                  ),
                  shape:
                  RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),



              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        "About Pluvia Weather",
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
                  shape:
                      RoundedRectangleBorder(borderRadius: kBorderRadius),
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
                          ? Image.asset(
                              "assets/GitHub-Mark-Light-64px.png")
                          : Image.asset("assets/GitHub-Mark-64px.png"),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text(
                        "View Pluvia Weather on Github",
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
