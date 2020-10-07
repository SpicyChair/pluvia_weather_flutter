import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/components/hourly_card.dart';
import 'package:flutter_weather/components/info_card.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/services/time.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:flutter_weather/services/extensions.dart';
import 'package:intl/intl.dart';

class DailyCard extends StatelessWidget {
  final data; //daily forecast data
  final isTomorrow; //shows the hourly data instead in expanded

  const DailyCard({this.data, this.isTomorrow});

  @override
  Widget build(BuildContext context) {
    //get the date of forecast and convert to human
    int offset = WeatherModel.getSecondsTimezoneOffset();
    DateTime forecastDate =
        TimeHelper.getDateTimeSinceEpoch(data["dt"], offset);
    String weekDay = TimeHelper.getWeekdayAsString(forecastDate.weekday);

    //parse data
    int highTemp = data["temp"]["max"].round();
    int lowTemp = data["temp"]["min"].round();
    String icon = WeatherModel.getIcon(data["weather"][0]["id"]);
    String description = data["weather"][0]["description"];

    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnCollapse: true,
        scrollOnExpand: true,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
          color: Colors.white,
          child: ExpandablePanel(
            header: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
              height: 70,
              width: double.infinity,
              child: Center(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  title: Text(
                    description.toTitleCase(),
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 55,
                        child: Center(
                          child: Text(
                            "${weekDay.substring(0, 3).toUpperCase()}",
                            style: kDateTextStyle,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          icon,
                          style: kHourlyCardIcon,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        child: Center(
                          child: Text(
                            "${highTemp.toString()}°",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: 42,
                        child: Center(
                          child: Text(
                            "${lowTemp.toString()}°",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            expanded: buildExpanded(data),
            tapBodyToCollapse: true,
            tapHeaderToExpand: true,
          ),
        ),
      ),
    );
  }

  Widget buildExpanded(var data) {
    int offset = WeatherModel.getSecondsTimezoneOffset();

    double uvIndex = data["uvi"].toDouble();

    int humidity = data["humidity"].round();

    int pressure = data["pressure"].round();

    DateTime sunriseTime =
        TimeHelper.getDateTimeSinceEpoch(data["sunrise"].toInt(), offset);

    DateTime sunsetTime =
        TimeHelper.getDateTimeSinceEpoch(data["sunset"].toInt(), offset);

    int windSpeed = data["wind_speed"].round();

    int windDirection = data["wind_deg"].round();

    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 2,
        crossAxisCount: 3,
        children: [
          InfoCard(
            title: "Sunrise",
            value: "${DateFormat.Hm().format(sunriseTime)}",
          ),
          InfoCard(
            title: "Sunset",
            value: "${DateFormat.Hm().format(sunsetTime)}",
          ),
          InfoCard(
            title: "Wind",
            value:
            "${windSpeed.toString()} ${WeatherModel.unit == "imperial" ? "mph" : "m/s"} ${WeatherModel.getWindCompassDirection(windDirection)}",
          ),
          InfoCard(
            title: "UV Index",
            value: uvIndex.toString(),
          ),
          InfoCard(
            title: "Humidity",
            value: "${humidity.toString()}%",
          ),
          InfoCard(
            title: "Pressure",
            value: "${pressure.toString()} hPa",
          ),
        ],
      ),
    );
  }
}
/*
Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 70,
                child: Center(
                  child: Text(
                    "${weekDay.substring(0, 3).toUpperCase()}",
                    style: kDateTextStyle,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: kHourlyCardIcon,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    description.toTitleCase(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(

                width: 70,
                child: Row(
                  children: [

                  ],
                ),
              ),
            ],
          ),
 */
