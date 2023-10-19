
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicTextfield extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;
  const BasicTextfield({super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });
  @override
  Widget build(BuildContext context){
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color:Colors.black26)
        ),
      ),

    );

  }
}