import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
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
        automaticallyImplyLeading: true,
        title: Text(Language.getTranslation("addLocation"), style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.blueAccent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
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
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15,
                        //fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).primaryColorLight,
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
