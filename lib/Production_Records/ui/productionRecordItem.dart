import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductionRecordItem extends StatefulWidget {
  final String date;
  final String product;
  final String productQuantity;
  const ProductionRecordItem(
      {super.key,
      required this.date,
      required this.product,
      required this.productQuantity});

  @override
  State<ProductionRecordItem> createState() => _ProductionRecordItemState();
}

class _ProductionRecordItemState extends State<ProductionRecordItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 10, top: 5),
      child: SizedBox(
        height: 104,
        width: MyUtility(context).width * 0.88,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 110,
              height: 30,
              decoration: BoxDecoration(
                color: MyColors().black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  widget.date,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: MyUtility(context).width * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      elevation: 6,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.north,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harvest Report',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.product,
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.productQuantity,
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
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
