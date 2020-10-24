import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/constants/text_style.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  InfoCard({
    this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      elevation: 0, //ThemeColors.isDark ? 0 : 1, //only elevate if not dark mode
      color: ThemeColors.cardColor(),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: kInfoCardTitle.copyWith(color: ThemeColors.secondaryTextColor())
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              value == "null" ? "-" : value,
              style: kInfoCardInfoText.copyWith(color: ThemeColors.primaryTextColor())
            ),
          ],
        ),
      ),
    );
  }
}
