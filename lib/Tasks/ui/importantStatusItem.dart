import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImportantStatusItem extends StatelessWidget {
  const ImportantStatusItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color.fromRGBO(252, 39, 39, 0.38)),
      child: Center(
        child: Text(
          'Important',
          style: GoogleFonts.roboto(
            color: MyColors().brightRed
          ),
        ),
      ),
    );
  }
}
