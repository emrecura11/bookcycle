

import 'package:flutter/material.dart';

import '../widgets/basic_button.dart';
import '../widgets/basic_textfield.dart';
import '../widgets/bottomnavbar.dart';
import 'home_page.dart';

class ChangePassword extends StatelessWidget{
  ChangePassword({super.key});
  final currentPasswordController=TextEditingController();
  final newPasswordController=TextEditingController();
  final newPasswordController2=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECDC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [

                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontFamily: 'Kurale',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),

                ),
                const SizedBox(
                  height: 25,
                ),
                BasicTextfield(
                  controller: currentPasswordController,
                  hintText: 'Current Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                //password textfiled
                BasicTextfield(
                  controller: newPasswordController,
                  hintText: 'New Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                BasicTextfield(
                  controller: newPasswordController2,
                  hintText: 'New Password Again',
                  obscureText: true,
                ),

                const SizedBox(height: 25),
                //sign in button
                BasicButton(
                  onTap: () {
                    if(newPasswordController.text == newPasswordController2.text&&newPasswordController.text.isNotEmpty){
                      showSnackBar(context, "Password change successfully");
                    }
                    else{
                      showSnackBar(context, "New passwords do not match or old password is incorrect");
                    }
                  },
                  buttonText: "Confirm",
                ),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),

    );

  }
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
