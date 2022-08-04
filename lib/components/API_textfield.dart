import 'package:flutter/material.dart';

class APITextField extends StatelessWidget {
  final String hintText;
  final Function onChanged;

  APITextField({this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Theme.of(context).primaryColorLight),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontSize: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColorDark, width: 2.0),
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
              BorderSide(color: Theme.of(context).primaryColorDark, width: 2.0),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
