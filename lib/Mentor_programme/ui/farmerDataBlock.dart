import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerDataBlock extends StatefulWidget {
  final String age;
  final String country;
  final String yearsExp;
  final String province;
  final String fgwExp;
  final String city;
  final String englishProf;
  const FarmerDataBlock(
      {super.key,
      required this.age,
      required this.country,
      required this.yearsExp,
      required this.province,
      required this.fgwExp,
      required this.city,
      required this.englishProf});

  @override
  State<FarmerDataBlock> createState() => _FarmerDataBlockState();
}

class _FarmerDataBlockState extends State<FarmerDataBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyUtility(context).width,
      decoration: BoxDecoration(
        color: MyColors().black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      'Age : ${widget.age}',
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      widget.country,
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      '${widget.yearsExp} Years Experience',
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      widget.province,
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      '${widget.fgwExp} FGW Experience',
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      widget.city,
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: MyUtility(context).width * 0.50 - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      'English Proficiency : ${widget.englishProf}',
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
