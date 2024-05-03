import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/basic_textfield.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false; // hatırlama durumunu tutacak değişken

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
              child: Container(
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
                          "Hoşgeldiniz!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[900],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
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
                                  )
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
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        BasicTextfield(
                                          controller: passwordController,
                                          obscureText: true,
                                          labelText: 'Şifre',
                                          inputType: TextInputType.visiblePassword,
                                          prefixIcon: Icon(Icons.vpn_key),
                                        ),
                                        SizedBox(height: height*0.02,),
                                        Row(
                                          children: <Widget>[
                                            Spacer(),
                                            Checkbox(
                                              value: rememberMe,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  rememberMe = value!;
                                                });
                                              },
                                            ),
                                            Text('Beni Hatırla'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(height: height*0.02,),
                        FadeInUp(duration: Duration(milliseconds: 1500),
                            child: Text("Şifremi unuttum",
                              style: TextStyle(color: Colors.grey),)),
                        SizedBox(height: height*0.02,),
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                            },
                            child: Text(
                              "Hesabım yok!",
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.02,),
                        FadeInUp(duration: Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>HomePage(),
                                  ),
                                );
                              },
                              height: 50,
                              // margin: EdgeInsets.symmetric(horizontal: 50),
                              color: Colors.deepOrange.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),

                              ),
                              // decoration: BoxDecoration(
                              // ),
                              child: Center(
                                child: Text("Giriş", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                              ),
                            )),
                        SizedBox(height: height*0.01,),

                          ],
                        )
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }

