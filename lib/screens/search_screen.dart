import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(Language.getTranslation("addLocation")),
        centerTitle: true,
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: /*Text(
                "Tap the above search bar to find a location",
                style: TextStyle(
                  color: ThemeColors.primaryTextColor(),
                  fontSize: 15,
                ),
              ),
              */
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      Language.getTranslation("tapTheSearchBar"),
                      style: TextStyle(
                        color: ThemeColors.primaryTextColor(),
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SvgPicture.asset(
                    "assets/undraw_Location_search_re_ttoj.svg",
                    semanticsLabel: "Search Illustration",
                    height: 210,
                  ),
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: MapBoxPlaceSearchWidget(
                popOnSelect: false,
                apiKey: env["MAPBOX_API_KEY"],
                searchHint: Language.getTranslation("searchForLocation"),
                onSelected: (place) {
                  Navigator.pop(context, place);
                },
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
