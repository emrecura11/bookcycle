import 'package:bookcycle/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../widgets/basic_button.dart';
import '../widgets/basic_textfield.dart';

class SignupPage extends StatelessWidget{
  SignupPage({super.key});
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final usernameController=TextEditingController();
  final passwordAgainController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),


                SizedBox(height:height*0.01),
                Stack(
                  children: const <Widget>[
                    // Solid text as fill.
                    Text(
                      'Kayıt ol',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height:height*0.04),



                //username textfield
                BasicTextfield(
                  controller: usernameController,
                  obscureText: false,
                  labelText:'Kullanıcı Adı' ,
                  prefixIcon: Icon(Icons.person),
                ),
                SizedBox(height:height*0.01),

                BasicTextfield(
                  controller: emailController,
                  obscureText: false,
                  labelText:'Email' ,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height:height*0.01),
                //password textfiled
                BasicTextfield(
                  controller: passwordController,
                  obscureText: true,
                  labelText:'Şifre' ,
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                SizedBox(height:height*0.01),
                BasicTextfield(
                  controller: passwordAgainController,
                  obscureText: false,
                  labelText:'Şifrenizi tekrar girin' ,
                  prefixIcon: Icon(Icons.check_rounded,)
                ),
                SizedBox(height:height*0.04),


                //sign in button
                BasicButton(
                  onTap: () {
                    //loginUser(context);
                    // Use the value of 'success' if needed
                  },
                  buttonText: "Kayıt ol",
                ),
                SizedBox(height:height*0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Hesabım var!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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