import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> deleteUserAccount(String userId) async {
  final url = Uri.parse('https://bookcycle.azurewebsites.net/api/Account/delete-account?userId=$userId');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      prefs.remove('jwtoken');
      prefs.remove('userName');
      prefs.remove('userId');
      prefs.remove('email');
      prefs.remove('password');
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;

  }
}


