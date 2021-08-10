import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';

class APITextField extends StatelessWidget {
  final String hintText;
  final Function onChanged;

  APITextField({this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: ThemeColors.primaryTextColor()),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: ThemeColors.secondaryTextColor(),
          fontSize: 15,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ThemeColors.secondaryTextColor(), width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: ThemeColors.secondaryTextColor(), width: 2.0),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
