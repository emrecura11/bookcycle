import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> addFavorite(BuildContext context, String userId, int bookId) async {
  final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Favorites');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwtoken');

  Map<String, dynamic> requestBody = {
    'userId': userId,
    'bookId': bookId,
  };

  try {
    http.Response response = await http.post(
      apiUrl,
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Book added to favorites successfully"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Failed to add book to favorites!"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Error: $e"),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
