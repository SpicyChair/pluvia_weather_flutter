import 'package:flutter/material.dart';
import 'package:flutter_weather/components/daily_card.dart';
import 'package:flutter_weather/components/hourly_card.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:flutter_weather/services/weather_model.dart';

class DailyForecastScreen extends StatefulWidget {
  final Function onChooseLocationPressed;
  DailyForecastScreen({this.onChooseLocationPressed});
  @override
  _DailyForecastScreenState createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  var dailyData;
  double lat;
  double lon;

  void initState() {
    super.initState();
    if (WeatherModel.weatherData != null) {
      updateUI();
    }
  }

  void updateUI() {
    dailyData = WeatherModel.weatherData["daily"];
    lat = WeatherModel.weatherData["lat"].toDouble();
    lon = WeatherModel.weatherData["lon"].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (dailyData == null) {
      return Center(child: Text("Choose a location to view weather."),);
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              height: 70,
              child: SizedBox(
                width: 350,
                child: Text(
                  WeatherModel.locationName,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 30,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: RefreshIndicator(

                  onRefresh: () async {
                    WeatherModel.getCoordLocationWeather(lat, lon, WeatherModel.locationName);
                    updateUI();
                  },
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return DailyCard(
                        //adding one excludes the current day
                        data: dailyData[index + 1],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    itemCount: 7,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
