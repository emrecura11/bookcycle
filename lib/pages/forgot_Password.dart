import 'package:flutter/material.dart';
import 'package:bookcycle/pages/verificationCode.dart';
import 'package:bookcycle/service/register.dart'; // Ensure this service is implemented if necessary
import 'package:bookcycle/widgets/basic_textfield.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  TextEditingController emailController = TextEditingController();
  Future<void> sendResetPasswordRequest(BuildContext context) async {
    final url = Uri.parse('https://bookcycle.azurewebsites.net/api/Account/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'origin': 'https://bookcycle.azurewebsites.net'},
        body: jsonEncode({'email': emailController.text}),
      );


      if (response.statusCode == 200) {
        // İşlem başarılı, VerificationCode sayfasına yönlendir
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCode(email: emailController.text),
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade300,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.deepOrange.shade300,
                Colors.deepOrange.shade300,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
                height: height * 0.30,
                width: width,
                fit: BoxFit.contain,
              ),
              Container(
                height: height * 0.70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Şifre Yenileme",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      Text(
                        "Şifre Yenileme için Email adresinize bir yenileme kodu göndereceğiz.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: BasicTextfield(
                                  controller: emailController,
                                  obscureText: false,
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(height: height * 0.02),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () => sendResetPasswordRequest(context),
                          height: 50,
                          color: Colors.deepOrange.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "GÖNDER",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
