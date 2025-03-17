import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonButton extends StatelessWidget {
  final double customWidth;
  final String buttonText;
  final Function() onTap;
  final bool? styleTwo;
  final Color? buttonColor;
  final Color? textColor;
  final double? customHeight;
  const CommonButton(
      {super.key,
      required this.customWidth,
      required this.buttonText,
      required this.onTap,
      this.styleTwo,
      this.buttonColor,
      this.textColor,
      this.customHeight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: customHeight ?? 55,
        width: customWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: buttonColor ?? MyColors().black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: styleTwo == true
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSlab(
                    fontSize: MyUtility(context).width < 404 ? 16 : 18,
                    fontWeight: FontWeight.w400,
                    color: textColor ?? Colors.white),
              ),
              Visibility(
                visible: styleTwo == true,
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
