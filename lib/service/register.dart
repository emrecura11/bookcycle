import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<void> signUpUser(BuildContext context, String username, String email,
    String password, String confirmPassword) async {
    String apiUrl = 'https://bookcycle.azurewebsites.net/api/Account/register';

    Map<String, dynamic> requestBody = {
      'email': email,
      'userName': username,
      'password': password,
      "confirmPassword": confirmPassword
    };


    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json', 'origin': 'https://bookcycle.azurewebsites.net/'},
      );

      if (response.statusCode == 200) {

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Kayıt Başarılı"),
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
        print(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Hata! Kayıt başarısız!"),
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
