

import 'package:bookcycle/pages/signup_page.dart';
import 'package:flutter/material.dart';

import '../widgets/basic_button.dart';
import '../widgets/basic_textfield.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: height*0.07),
                Image.asset('images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: height*0.04),

                Stack(
                  children: const <Widget>[
                    // Solid text as fill.
                    Text(
                      'Hoşgeldiniz!',
                      style: TextStyle(
                        fontSize: 34,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height*0.04),
                //welcome back!

                //username textfield
                BasicTextfield(
                  controller: emailController,
                  obscureText: false,
                  labelText:'Email' ,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: height*0.02),
                //password textfiled
                BasicTextfield(
                  controller: passwordController,
                  obscureText: true,
                  labelText:'Şifre' ,
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                SizedBox(height:height*0.02),
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => this,
                            ),
                          );
                        },
                        child: const Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height*0.07),
                //sign in button
                BasicButton(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> HomePage()),);
                  },
                  buttonText: "Giriş",
                ),

                //not a member? Register now
                SizedBox(height: height*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabınız yok mu?'),
                    SizedBox(height: height*0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          },
                          child: const Text(
                            'Kayıt ol!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
