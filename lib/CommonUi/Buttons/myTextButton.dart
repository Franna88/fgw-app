import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool? underline;
  const MyTextButton(
      {super.key, required this.text, required this.onTap, this.underline});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.roboto(
            color: const Color.fromARGB(255, 221, 177, 20),
            fontSize: 16,
            decoration: underline == true ? TextDecoration.underline : null,
            decorationColor: const Color.fromARGB(255, 221, 177, 20), 
            ),
      ),
    );
  }
}
