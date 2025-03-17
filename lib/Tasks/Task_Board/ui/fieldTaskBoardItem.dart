import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/myutility.dart';

class FieldTaskBoardItem extends StatelessWidget {
  final String row;
  final String tasksComplete;
  final String faze;
  final double progressValue;
  final bool isImportant;
  final Function() onTap;
  const FieldTaskBoardItem(
      {super.key,
      required this.row,
      required this.tasksComplete,
      required this.faze,
      required this.progressValue,
      required this.isImportant,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: isImportant,
              child: Container(
                width: MyUtility(context).width * 0.20,
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: MyColors().brightRed),
              ),
            ),
            Container(
              height: 115,
              width: MyUtility(context).width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row,
                      style: GoogleFonts.roboto(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MyUtility(context).width * 0.85 - 80,
                          child: LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 12,
                            backgroundColor:
                                const Color.fromARGB(255, 221, 221, 221),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color.fromARGB(255, 95, 199, 98),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text(
                          tasksComplete,
                          style: GoogleFonts.roboto(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faze,
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
