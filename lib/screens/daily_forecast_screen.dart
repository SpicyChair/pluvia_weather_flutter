import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather/components/daily_card.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
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
  bool imperial;
  WindUnit unit;

  bool isLoading = true;

  void initState() {
    super.initState();
    if (!(WeatherModel.weatherData == 401 || WeatherModel.weatherData == 429 || WeatherModel.weatherData == null)) {
      updateUI();
    }
  }

  Future<void> updateUI() async {
    dailyData = WeatherModel.weatherData["daily"];
    lat = WeatherModel.weatherData["lat"].toDouble();
    lon = WeatherModel.weatherData["lon"].toDouble();

    imperial = await SharedPrefs.getImperial();
    unit = await SharedPrefs.getWindUnit();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dailyData == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Text(
            dailyData == null
                ? Language.getTranslation("chooseLocationToView")
                : Language.getTranslation("loading"),
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Text(
            WeatherModel.locationName,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 30,
              color: Theme.of(context).primaryColorLight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            ButtonTheme(
              minWidth: 0,
              child: FlatButton(
                onPressed: refresh,
                child: Icon(
                  Icons.refresh_outlined,
                  size: 27,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: isLoading
            ?
            //if is loading
            Center(
                child: Column(
                children: [
                  SpinKitFadingCircle(
                    color: Theme.of(context).primaryColorDark,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Language.getTranslation("loading"),
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ))
            :
            //if loaded
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return DailyCard(
                          data: dailyData[index + 1],
                          imperial: imperial,
                          unit: unit,
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
      ),
    );
  }

  Future<void> refresh() async {
    await WeatherModel.getCoordLocationWeather(
        latitude: lat, longitude: lon, name: WeatherModel.locationName);
    updateUI();
    DateTime now = DateTime.now();
    String refreshTime = TimeHelper.getReadableTime(now);
    Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text("${Language.getTranslation("lastUpdatedAt")} $refreshTime")));
  }
}
