import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/services/weather_model.dart';
import 'package:flutter/material.dart';
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
    return Card(
      elevation: 0,
      color: Colors.transparent,
      key: ValueKey(data.id),
      child: ListTile(
        onTap: () async {
          await WeatherModel.getCoordLocationWeather(latitude: data.latitude, longitude: data.longitude, name: data.title);
          onLocationSelect(0);
        },
        onLongPress: onLongPress,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: Text(
          data.title,
          style: kSubheadingTextStyle.copyWith(
              color: Theme.of(context).primaryColorLight),
          overflow: TextOverflow.fade,
        ),
        subtitle: Text(
          data.getCoordinates(),
          style: kSubtitleTextStyle.copyWith(
              color: Theme.of(context).primaryColorDark),
        ),
      ),
    );
  }
}
