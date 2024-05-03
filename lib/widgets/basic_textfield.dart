import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final TextInputType? inputType;
  final bool obscureText;

  const BasicTextfield({
    Key? key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.inputType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _BasicTextfieldState createState() => _BasicTextfieldState();
}

class _BasicTextfieldState extends State<BasicTextfield> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && _obscureText,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15),
          ),
          fillColor: const Color(0xFFEAEAEA),
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText &&
              widget.inputType == TextInputType.visiblePassword
              ? InkWell(
            onTap: _togglePasswordVisibility,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          )
              : null,
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
