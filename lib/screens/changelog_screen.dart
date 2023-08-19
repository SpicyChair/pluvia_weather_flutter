import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChangelogScreen extends StatelessWidget {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
      Uri.parse(
          'https://github.com/SpicyChair/pluvia_weather_flutter/releases'),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Language.getTranslation("changelog"),
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          leading: TextButton(
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: WebViewWidget(
          controller: controller,
        ));
  }
}

/*

 */
