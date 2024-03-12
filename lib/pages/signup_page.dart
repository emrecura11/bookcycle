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
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('images/logo_bookcycle.jpeg',
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),


                const SizedBox(height: 15),
                Stack(
                  children: const <Widget>[
                    // Solid text as fill.
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'LexendExa',
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),



                //username textfield
                BasicTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                BasicTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //password textfiled
                BasicTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                BasicTextfield(
                  controller: passwordAgainController,
                  hintText: 'Password again',
                  obscureText: false,
                ),
                const SizedBox(height: 15),


                //sign in button
                BasicButton(
                  onTap: () {
                    //loginUser(context);
                    // Use the value of 'success' if needed
                  },
                  buttonText: "Signup",
                ),
                const SizedBox(height: 15),
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
                        'I already have account!',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kurale',
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