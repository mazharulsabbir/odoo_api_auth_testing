```dart
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> login({String? username, String? password}) async {
    String _body = convert.jsonEncode({
      "params": {
        "db": "odoo13",
        "login": username,
        "password": password
      }
    });

    try {
      var url = Uri.parse('http://192.168.10.131:8013/web/session/authenticate');
      http.Response response = await http.post(
        url,
        body: _body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );

      String? cookie = response.headers['set-cookie']?.split(';').first;

      var url2 = Uri.parse('http://192.168.10.131:8013/api/notification');
      http.Response? response2 = await http.get(url2, headers: {
        'Cookie': '$cookie',
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      });
      
      return Future.value(response2);
    } catch (e) {
      return Future.error(e);
    }
  }
}
```
