
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<void> deleteFavorite(String userId, int bookId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwtoken');
  // API endpoint with parameters
  final url = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Favorites?userId=$userId&bookId=$bookId');

  try {
    // Send DELETE request
    final response = await http.delete(url,
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'},);

    // Check response status
    if (response.statusCode == 200) {
      print('Favorite deleted successfully');
    } else {
      print('Failed to delete favorite. Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to delete favorite. Error: $e');
  }
}