import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';

class AdvancedSettings extends StatefulWidget {

  @override
  _AdvancedSettingsState createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced Settings"),
        centerTitle: true,
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      body: ,
    );
  }
}
