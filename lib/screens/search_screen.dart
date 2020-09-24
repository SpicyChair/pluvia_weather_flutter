import 'package:flutter/material.dart';
import 'package:flutter_weather/services/api_keys.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';

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
        title: Text("Location Search"),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: MapBoxPlaceSearchWidget(
            
            popOnSelect: false,
            apiKey: kMapBoxApiKey,
            limit: 8,
            searchHint: 'Search for a location',
            onSelected: (place) {
              Navigator.pop(context, place);
            },
            context: context,
          ),
        ),
      ),
    );
  }
}
