import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/database/database.dart';
import 'dart:async';

class LocationCard extends StatelessWidget {
  var data;
  Function(int) onLocationSelect;
  Function() onLongPress;
  Function() refresh;
  Timer _timer;

  LocationCard({data, onLocationSelect, refresh, onLongPress}) {
    this.data = data;
    this.onLocationSelect = onLocationSelect;
    this.refresh = refresh;
    this.onLongPress = onLongPress;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await WeatherModel.getCoordLocationWeather(
            data.latitude, data.longitude, data.title);
        onLocationSelect(0);
      },
      child: GestureDetector(

        //TODO: CHANGE DURATION OF onPanDown
        onPanCancel: () => _timer?.cancel(),
        onPanDown: (_) => {_timer = Timer(Duration(milliseconds: 850), onLongPress)},



        child: Card(
          elevation: 0,
          color: Colors.transparent,
          key: ValueKey(data.id),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            title: Text(
              data.title,
              style: kSubheadingTextStyle.copyWith(
                  color: ThemeColors.primaryTextColor()),
              overflow: TextOverflow.fade,
            ),
            subtitle: Text(
              data.getCoordinates(),
              style: kSubtitleTextStyle.copyWith(
                  color: ThemeColors.secondaryTextColor()),
            ),
          ),
        ),
      ),
    );
  }
}
