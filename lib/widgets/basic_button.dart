import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  const BasicButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.05,

        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFF88C4A8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontFamily: 'Kurale',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}