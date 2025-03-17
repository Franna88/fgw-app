import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmersGuideCategoryItems extends StatefulWidget {
  final String image;
  final String name;
  final Function() onTap;
  const FarmersGuideCategoryItems(
      {super.key, required this.image, required this.name, required this.onTap});

  @override
  State<FarmersGuideCategoryItems> createState() =>
      _FarmersGuideCategoryItemsState();
}

class _FarmersGuideCategoryItemsState extends State<FarmersGuideCategoryItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 250,
          width: MyUtility(context).width - 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Text(
              widget.name,
              style: GoogleFonts.robotoSlab(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
