import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<int>> getFavorites(String email, List<int> idList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  final apiUrl = Uri.parse('https://localhost:9001/api/v1/Favorites/$email');

  try {
    http.Response response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> data = responseData['data'];
      for (var item in data) {
        int bookId = item['bookId'];
        if (!idList.contains(bookId)) {
          idList.add(bookId);
        }
      }
      return idList;
    } else {

      return []; // Hata durumunda
    }
  } catch (e) {
    return []; // Hata durumunda
  }
}
