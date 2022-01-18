import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> login(
      {String? username, String? password}) async {
    String _body = convert.jsonEncode({
      "params": {
        "db": "odoo13",
        "login": username ?? "sabbir.apps@daffodil-bd.com",
        "password": password ?? "odoo13"
      }
    });

    try {
      var url =
          Uri.parse('http://192.168.10.131:8013/web/session/authenticate');
      http.Response response = await http.post(
        url,
        body: _body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      String? cookie = response.headers['set-cookie']?.split(';').first;
      print('Response Headers: $cookie');

      var url2 = Uri.parse('http://192.168.10.131:8013/api/notification');
      http.Response? response2 = await http.get(url2, headers: {
        'Cookie': '$cookie',
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      });
      print('Response Headers: ${response2.headers}');
      return Future.value(response2);
    } catch (e) {
      return Future.error(e);
    }
  }
}
