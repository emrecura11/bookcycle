import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Book.dart';

Future<List<Book>> getFilteredBooks(List<String> genres, bool? isAskida, String? startDate, String? endDate) async {
  final queryParams = {
    'genres': genres.isNotEmpty ? genres.join(',') : null,
    'isAskida': isAskida?.toString() ?? 'false',
    'startDate': startDate,
    'endDate': endDate,
  };

  final filteredParams = queryParams..removeWhere((key, value) => value == null);

  // Build URI with the encoded query parameters
  final uri = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book/filter').replace(queryParameters: filteredParams);

  try {
    // Log the final URI with all parameters
    print('API request URL: $uri');

    final response = await http.get(uri, headers: {'accept': '*/*'});

    // Log the response status and body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Adjust to the correct field name containing the data
      final List<dynamic> booksData = jsonResponse['data'];

      return booksData.map((data) => Book.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load filtered books. Status code: ${response.statusCode}.');
    }
  } catch (e) {
    throw Exception('Failed to load filtered books: $e');
  }
}
