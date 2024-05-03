import 'package:bookcycle/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../widgets/basic_textfield.dart';
import 'package:animate_do/animate_do.dart';
class SignupPage extends StatelessWidget{
  SignupPage({super.key});
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final usernameController=TextEditingController();
  final passwordAgainController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.deepOrange.shade300,
                    Colors.deepOrange.shade300,
                  ]
              )
          ),
          child: Column(
        
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
                height: MediaQuery.of(context).size.height * 0.35, // Yüksekliği %30'a indirdim
                width: MediaQuery.of(context).size.width , // Genişliği %80'e indirdim
                fit: BoxFit.contain, // Orantılı olarak sığdırmak için BoxFit.contain kullanılır
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Kayıt Olun!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[900],
                          ),
                        ),
                        SizedBox(height: height*0.01,),
                        FadeInUp(duration: Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                  )
                                  ]
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey.shade200))
                                    ),
                                    child: BasicTextfield(
                                      controller: usernameController,
                                      obscureText: false,
                                      labelText: 'Kullanıcı Adı',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey.shade200))
                                    ),
                                    child:  BasicTextfield(
                                      controller: emailController,
                                      obscureText: false,
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey.shade200))
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
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey.shade200))
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
                            )),
        
                        SizedBox(height: height*0.02,),
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              "Hesabım zaten var!",
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
                                    builder: (context) =>LoginPage(),
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
                                child: Text("Kayıt ol", style: TextStyle(
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
