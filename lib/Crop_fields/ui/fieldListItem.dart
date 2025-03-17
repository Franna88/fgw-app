import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldListItem extends StatelessWidget {
  final String fieldName;
  final String imagePath;

  const FieldListItem({
    super.key,
    required this.fieldName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Container(
            height: MyUtility(context).height * 0.25,
            width: MyUtility(context).width * 0.86,
            decoration: BoxDecoration(
               boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(2, 0)
                )
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 55,
            width: MyUtility(context).width * 0.86,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(2, 2)
                )
              ]
            ),
            child: Center(
              child: Text(
                fieldName,
                style: GoogleFonts.roboto(
                    fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
