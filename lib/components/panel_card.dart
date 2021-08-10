import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';

class PanelCard extends StatelessWidget {
  final Widget cardChild;

  PanelCard({
    this.cardChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor(),

      ),
    );
  }
}
