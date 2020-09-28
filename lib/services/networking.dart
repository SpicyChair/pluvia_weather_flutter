import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:convert';

class NetworkHelper {
  final String url;

  NetworkHelper({this.url});

  Future getData() async {
    try {
      http.Response response = await http.get(url).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        //if the response is successful
        String data = response.body;
        //return decoded data
        return jsonDecode(data);
      }
    } on SocketException catch (_) {
    } on TimeoutException catch (_) {
    }
    return null;
  }


}