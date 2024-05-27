import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserService {
  final String baseUrl;

  UpdateUserService({required this.baseUrl});

  /// Kullanıcı bilgilerini günceller
  Future<bool> updateUser({
    required String userId,
    required String userName,
    required String location,
    required String description,
    required String base64Image,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');

    // JSON verisini hazırla
    final String jsonBody = jsonEncode({
      'id': userId,
      'userName': userName,
      'location': location,
      'description': description,
      'userImage': base64Image,
    });

    // HTTP PUT isteği yap
    final response = await http.put(
      Uri.parse('$baseUrl/update-user?userId=$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    // Başarılı olup olmadığını kontrol et
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update user: ${response.body}');
      return false;
    }
  }
}
