import 'package:flutter/material.dart';

class ScreenAppBar extends StatelessWidget {

  final String title;
  final IconData icon;
  final Function onPressed;


  ScreenAppBar({this.title, this.icon, this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context).brightness,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      title: Text(
        this.title,
        style: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 30,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: onPressed,
            child: Icon(
              this.icon,
              size: 27,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
