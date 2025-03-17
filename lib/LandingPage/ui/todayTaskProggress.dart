import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayTaskProggress extends StatefulWidget {
  const TodayTaskProggress({super.key});

  @override
  State<TodayTaskProggress> createState() => _TodayTaskProggressState();
}

class _TodayTaskProggressState extends State<TodayTaskProggress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: MyUtility(context).width * 0.90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: [
          Container(
            height: 30,
            width: MyUtility(context).width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: MyColors().yellow,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                'Today\'s Task Progress',
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Text(
                '3 / 10',
                style:
                    GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: LinearProgressIndicator(
              value: 0.5,
              minHeight: 12,
              backgroundColor: const Color.fromARGB(255, 221, 221, 221),
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color.fromARGB(255, 95, 199, 98),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
