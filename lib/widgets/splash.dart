import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bookcycle/pages/login_page.dart'; // Assuming your login page is named LoginPage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3), // 3 saniye sonra splash ekranı kapanacak
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade300,
      body: Center(
        child: Image.asset(
          'images/logo.png',
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width*2/3,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
