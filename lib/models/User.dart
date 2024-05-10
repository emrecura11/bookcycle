import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String email;
  final String userName;
  final String? userImage;
  User({
    required this.id,
    required this.email,
    required this.userName,
    this.userImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      userName: json['userName'],
      userImage: json['userImage'] as String?,
    );
  }
}