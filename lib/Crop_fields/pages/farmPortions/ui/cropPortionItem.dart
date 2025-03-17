import 'package:farming_gods_way/Crop_fields/pages/Full_Portion_view/fullPortionView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/myutility.dart';

class CropPortionItem extends StatefulWidget {
  final String crop;
  final String cropFaze;
  final String dayCount;
  final String rowNumber;
  final double progress;
  const CropPortionItem(
      {super.key,
      required this.crop,
      required this.cropFaze,
      required this.dayCount,
      required this.rowNumber,
      required this.progress});

  @override
  State<CropPortionItem> createState() => _CropPortionItemState();
}

class _CropPortionItemState extends State<CropPortionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FullPortionView()),
  );
      },
      child: Container(
        height: 70,
        width: MyUtility(context).width * 0.90 - 79,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 70,
              decoration: BoxDecoration(
                color: MyColors().black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  widget.rowNumber,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.crop,
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: MyUtility(context).width * 0.90 - 140,
                  child: LinearProgressIndicator(
                    value: 0.80,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
                SizedBox(
                  width: MyUtility(context).width * 0.90 - 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.cropFaze,
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.dayCount,
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ],
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
