import 'package:flutter/material.dart';
import 'package:bookcycle/pages/login_page.dart';
import 'package:bookcycle/widgets/basic_textfield.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatelessWidget {
  final String email;
  final String token;

  ResetPassword({super.key, required this.email, required this.token});

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    final String password = passwordController.text;
    final String confirmPassword = passwordAgainController.text;
    final String url = 'https://bookcycle.azurewebsites.net/api/Account/reset-password';

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifreler uyuşmuyor.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifreniz başarıyla yenilendi.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Password reset failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifre yenileme başarısız oldu.')),
        );
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu, lütfen tekrar deneyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade300, // Match the gradient color
        elevation: 0, // Remove shadow for a cleaner look
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // This pops the current route off the navigator
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
                        "Şifrenizi Yenileyebilirsiniz!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                      SizedBox(height: height * 0.04),

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
                                  controller: passwordController,
                                  obscureText: true,
                                  labelText: 'Şifre',
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Icon(Icons.vpn_key),
                                ),
                              ),
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
                                  controller: passwordAgainController,
                                  obscureText: true,
                                  labelText: 'Şifreyi Onayla',
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Icon(Icons.check),
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
                          onPressed: () => resetPassword(context),
                          height: 50,
                          color: Colors.deepOrange.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "YENİLE",
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
