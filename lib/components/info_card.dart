import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'file:///E:/flutter_weather/lib/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  InfoCard({
    this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.all(4),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: kBorderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: kInfoCardTitle
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            value,
            style: kInfoCardInfoText
          ),
        ],
      ),
    );
  }
}
