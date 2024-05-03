import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bookcycle/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();

}
Future<bool> getUser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  if(email!=null && password != null){
    return true;
  }else{
    return false;
  }
}

Future<void> toPage(BuildContext context) async {

  if(await getUser(context)){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()));
  }
  else{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()));
  }

}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
          () =>
              toPage(context)
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
