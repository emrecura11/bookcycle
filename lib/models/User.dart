import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String email;
   String userName;
   String? userImage;
   String? location;
   String? description;
  User({
    required this.id,
    required this.email,
    required this.userName,
    this.userImage,
    this.location,
    this.description
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      userName: json['userName'],
      userImage: json['userImage'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
    );
  }
}