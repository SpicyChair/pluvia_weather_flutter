import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:convert';

class NetworkHelper {
  final String url;

  NetworkHelper({this.url});

  Future getData() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //return a code to show that connection failed
      return 0;
    }


    try {
      http.Response response = await http.get(url).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        //if the response is successful
        String data = response.body;
        //return decoded data
        return jsonDecode(data);
      }
      //return a code to show that connection failed
      return 0;

    } on SocketException catch (_) {
      //return a code to show that connection failed
      return 0;

    } on TimeoutException catch (_) {
      //return a code to show that connection failed
      return 0;
    }
  }


}