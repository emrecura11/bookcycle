import 'dart:convert';
import 'package:bookcycle/pages/verification_Change.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/basic_button.dart';
import '../widgets/basic_textfield.dart';


class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordController2 = TextEditingController();
  String? email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  Future<void> sendResetPasswordRequest(BuildContext context) async {
    final url = Uri.parse('https://bookcycle.azurewebsites.net/api/Account/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'origin': 'https://bookcycle.azurewebsites.net'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationChange(email: email!),
          ),
        );
      } else {
        // Sunucu hata mesajı döndürdü, kullanıcıya uyarı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Şifre sıfırlama isteği başarısız oldu. Lütfen tekrar deneyin."),
            backgroundColor: Colors.red,
          ),
        );
        print("Failed to send password reset email. Status code: ${response.statusCode}");
        print("Error response body: ${response.body}");
      }
    } catch (e) {
      // HTTP isteği sırasında bir hata oluştu, kullanıcıya uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bir hata oluştu. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin."),
          backgroundColor: Colors.red,
        ),
      );
      print("An error occurred while sending password reset email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade300,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Şifre Değiştirme",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                if (email != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Kullanıcı hesabınızın kayıtlı olduğu ${_obfuscateEmail(email!)} email adresine doğrulama kodu göndereceğiz. Devam edelim mi?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 25),
                BasicButton(
                  onTap: () {
                    if (email != null) {
                      sendResetPasswordRequest(context);
                    } else {
                      showSnackBar(context, "Email address not found.");
                    }
                  },
                  buttonText: "Devam",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _obfuscateEmail(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex > 1) {
      String obfuscated = email[0] + "****" + email.substring(atIndex - 1);
      return obfuscated;
    }
    return email;
  }
}
