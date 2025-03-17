import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Constants/myutility.dart';

class PortionRowTaskItem extends StatefulWidget {
  final String row;
  final double progressValue;
  final String rowFaze;
  final Function() onTap;
  const PortionRowTaskItem(
      {super.key,
      required this.row,
      required this.progressValue,
      required this.rowFaze,
      required this.onTap});

  @override
  State<PortionRowTaskItem> createState() => _PortionRowTaskItemState();
}

class _PortionRowTaskItemState extends State<PortionRowTaskItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
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
                widget.row,
                style: GoogleFonts.roboto(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MyUtility(context).width * 0.85 - 80,
                    child: LinearProgressIndicator(
                      value: widget.progressValue,
                      minHeight: 12,
                      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightBlueAccent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: ShapeDecoration(
                      color: MyColors().black,
                      shape: CircleBorder(),
                    ),
                    child: Center(
                      child: Icon(Icons.checklist, color: Colors.white,),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.rowFaze,
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
