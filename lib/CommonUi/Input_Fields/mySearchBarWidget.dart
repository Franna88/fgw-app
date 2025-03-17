import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const MySearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: MyColors().offWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black54,
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ),
    );
  }
}
