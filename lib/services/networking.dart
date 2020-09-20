import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;

  NetworkHelper({this.url});

  Future getData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      //if the response is successful
      String data = response.body;
      print(data);
      //return decoded data
      return jsonDecode(data);
    }
    print(response.statusCode);
  }

}