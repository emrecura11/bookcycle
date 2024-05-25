import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/Book.dart';

  Future<Book> getBookById(int id) async {
  final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book/$id');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwtoken');

  Map<String, dynamic> requestBody = {
    'bookId': id,
  };

  try {
    http.Response response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return Book.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch book details! Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
