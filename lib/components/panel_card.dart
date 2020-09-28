import 'package:flutter/material.dart';
import 'file:///E:/flutter_weather/lib/constants/constants.dart';

class PanelCard extends StatelessWidget {

  Widget cardChild;
  bool darkMode;

  PanelCard({this.cardChild,});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: cardChild,
    );
  }

}