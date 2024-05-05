import 'package:shared_preferences/shared_preferences.dart';
import '../models/Book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Book>> getFilteredBooks(String genre, bool? isAskida, String startDate, String endDate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwtoken');

  final apiUrl = Uri.parse('https://localhost:9001/api/v1/Book/filter?genre=$genre&isAskida=$isAskida&startDate=$startDate&endDate=$endDate');

  try {
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Book.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load filtered books');
    }
  } catch (e) {
    throw Exception('Failed to load filtered books: $e');
  }
}
