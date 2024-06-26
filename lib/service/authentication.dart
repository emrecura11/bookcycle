import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<bool> authenticateUserWithApi(String email, String password) async {
  final url = Uri.parse('https://bookcycle.azurewebsites.net/api/Account/authenticate');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    String token = json.decode(response.body)['data']['jwToken'];
    String userName = json.decode(response.body)['data']['userName'];
    String userId = json.decode(response.body)['data']['id'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtoken', token);
    prefs.setString('userName', userName);
    prefs.setString('userId', userId);

    return true;
  } else {
    // Kullanıcı doğrulanamadı
    return false;
  }
}