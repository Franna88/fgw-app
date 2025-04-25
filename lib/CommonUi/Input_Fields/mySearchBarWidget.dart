import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MySearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onClear;
  final bool showClearButton;

  const MySearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = "Search...",
    this.onClear,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: MyColors().forestGreen,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: MyColors().forestGreen,
              size: 20,
            ),
            suffixIcon: (controller != null && 
                         controller!.text.isNotEmpty && 
                         showClearButton) 
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    controller!.clear();
                    if (onClear != null) {
                      onClear!();
                    }
                    if (onChanged != null) {
                      onChanged!('');
                    }
                  },
                  color: Colors.grey[500],
                )
              : null,
            hintText: hintText,
            hintStyle: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
    );
  }
}
