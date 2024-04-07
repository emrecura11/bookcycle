import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final String? labelText; // Opsiyonel
  final Icon? prefixIcon; // Opsiyonel

  const BasicTextfield({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false, // Varsayılan değer false
    this.labelText, // Opsiyonel, varsayılan değer null
    this.prefixIcon, // Opsiyonel, varsayılan değer null
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15), // Yuvarlak köşeler eklendi
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15), // Yuvarlak köşeler eklendi
          ),
          fillColor: const Color(0xFFEAEAEA),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          labelText: labelText, // Şimdi opsiyonel
          prefixIcon: prefixIcon, // Şimdi opsiyonel
        ),
      ),
    );
  }
}
