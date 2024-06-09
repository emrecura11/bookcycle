import 'dart:convert';
import 'package:bookcycle/models/Wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool?> updateWishlist(Wishlist wishlist) async {

  print('updateWishlist çağrıldı.');
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwtoken');

  final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Wishlist/${wishlist.id}');
  print('API URL: $apiUrl');
  print('Token: $token');

  try {
    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': wishlist.id,
        'name': wishlist.name,
        'author': wishlist.author,
        'stateOfBook': wishlist.stateOfBook,
        'description': wishlist.description,
        'createdBy': wishlist.createdBy,
        'created' : wishlist.created.toIso8601String(),

      }),
    );
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Güncelleme başarısız: ${response.statusCode}');
      print('Hata detayı: ${response.body}');
      return false;
    }
  } catch (e) {
    print('HTTP isteği sırasında bir hata oluştu: $e');
    return false;
  }

}