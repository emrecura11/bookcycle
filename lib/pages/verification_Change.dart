import 'package:flutter/material.dart';
import 'package:bookcycle/widgets/basic_button.dart';
import 'package:bookcycle/widgets/basic_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';

class VerificationChange extends StatefulWidget {
  final String email;

  VerificationChange({super.key, required this.email});

  @override
  _VerificationChangeState createState() => _VerificationChangeState();
}

class _VerificationChangeState extends State<VerificationChange> {
  final verificationCodeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    final url = Uri.parse('https://bookcycle.azurewebsites.net/api/Account/reset-password');

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Yeni şifreler eşleşmiyor."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'token': verificationCodeController.text,
          'Password': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // İşlem başarılı, kullanıcıya mesaj göster veya başka bir sayfaya yönlendir
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Şifre başarıyla değiştirildi."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
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
        print("Failed to reset password. Status code: ${response.statusCode}");
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
      print("An error occurred while resetting password: $e");
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Kullanıcı hesabınızın kayıtlı olduğu ${_obfuscateEmail(widget.email)} email adresine gönderilen doğrulama kodunu ve yeni şifrenizi girin.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                BasicTextfield(
                  controller: verificationCodeController,
                  obscureText: false,
                  labelText: 'Doğrulama Kodu',
                  prefixIcon: Icon(Icons.numbers),
                ),
                const SizedBox(height: 20),
                BasicTextfield(
                  controller: newPasswordController,
                  obscureText: true,
                  labelText: 'Şifre',
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                const SizedBox(height: 20),
                BasicTextfield(
                  controller: confirmPasswordController,
                  obscureText: true,
                  labelText: 'Şifreyi Onayla',
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.check),
                ),
                const SizedBox(height: 25),
                BasicButton(
                  onTap: () {
                    resetPassword(context);
                  },
                  buttonText: "DEĞİŞTİR",
                ),
              ],
            ),
          ),
        ),
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
