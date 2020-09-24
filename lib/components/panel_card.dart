import 'package:flutter/material.dart';
import 'file:///E:/flutter_weather/lib/constants/constants.dart';

class PanelCard extends StatelessWidget {

  Widget cardChild;
  bool darkMode;

  PanelCard({this.cardChild,});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      color: Colors.white.withOpacity(0.90),
      child: cardChild,
    );
  }

}