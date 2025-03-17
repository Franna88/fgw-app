import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerRequestItem extends StatefulWidget {
  final String farmerName;
  final String farmerImage;
  final String farmerEmail;
  final String farmerNumber;
  final Function() onTap;
  const FarmerRequestItem(
      {super.key,
      required this.farmerName,
      required this.farmerImage,
      required this.farmerEmail,
      required this.farmerNumber,
      required this.onTap});

  @override
  State<FarmerRequestItem> createState() => _FarmerRequestItemState();
}

class _FarmerRequestItemState extends State<FarmerRequestItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MyUtility(context).width,
      decoration: BoxDecoration(
        color: MyColors().offWhite,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      widget.farmerImage,
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.farmerName,
                  style: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.bold, height: 1),
                ),
                Text(
                  widget.farmerEmail,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.farmerNumber,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: widget.onTap,
              child: Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(76, 175, 80, 1),
                ),
                child: Center(
                  child: Text(
                    'Request',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
