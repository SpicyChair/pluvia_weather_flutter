import 'package:flutter/material.dart';
import 'package:flutter_weather/constants.dart';

class ForecastCard extends StatelessWidget {
  final String date;
  final String highTemperature;
  final String lowTemperature;
  final IconData icon;

  ForecastCard({
  @required this.date,
  @required this.highTemperature,
  @required this.lowTemperature,
  @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        child: InkWell (
          onTap: () {},
         borderRadius: kBorderRadius,
          child: ListTile(
            leading: Icon(icon),
            title: Text(date, style: kSubheadingTextStyle,),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$highTemperature°", style: kSubheadingTextStyle.copyWith(color: Colors.black),),
                SizedBox(width: 15.0,),
                Text("$lowTemperature°", style: kSubheadingTextStyle.copyWith(color: Colors.black54),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
