import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/User.dart';

Future<User> getUserInfo(String userId) async {
  final apiUrl = Uri.parse('https://localhost:9001/api/Account/user/$userId');


  try {
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to load user info');
    }
  } catch (e) {
    throw Exception('Failed to load user info: $e');
  }
}