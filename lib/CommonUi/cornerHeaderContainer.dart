import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CornerHeaderContainer extends StatelessWidget {
  final String header;
  final bool hasBackArrow;
  const CornerHeaderContainer(
      {super.key, required this.header,required this.hasBackArrow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyUtility(context).width * 0.93,
      height: 50,
      decoration: BoxDecoration(
        color: MyColors().offWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8)),
      ),
      child: hasBackArrow == false
          ? Center(
              child: Text(
                header,
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : Row(
              children: [
                const SizedBox(width: 15,),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                ),
                const Spacer(),
                Text(
                  header,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 40,),
              ],
            ),
    );
  }
}
