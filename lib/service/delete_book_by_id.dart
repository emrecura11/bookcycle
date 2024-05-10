import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> deleteBook(int bookId) async {
  final url = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book/$bookId');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwtoken');



  try {
    http.Response response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) {
      // Silme başarılı oldu
      print('Kitap başarıyla silindi.');
    } else {
      // Silme başarısız oldu
      print('Kitap silinirken bir hata oluştu. Hata kodu: ${response.statusCode}');
    }
  } catch (error) {
    print('Kitap silinirken bir hata oluştu: $error');
  }
}
