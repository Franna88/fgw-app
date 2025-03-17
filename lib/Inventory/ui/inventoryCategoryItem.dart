import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryCategoryItem extends StatefulWidget {
  final bool styleOne;
  final String image;
  final String name;
  final Function() onTap;
  const InventoryCategoryItem(
      {super.key,
      required this.styleOne,
      required this.image,
      required this.name,
      required this.onTap});

  @override
  State<InventoryCategoryItem> createState() => _InventoryCategoryItemState();
}

class _InventoryCategoryItemState extends State<InventoryCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 80,
          width: MyUtility(context).width,
          decoration: BoxDecoration(
            color: MyColors().offWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: ShapeDecoration(
                    shadows: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          color: const Color.fromARGB(255, 143, 143, 143),
                          blurRadius: 5)
                    ],
                    color: widget.styleOne ? MyColors().green : MyColors().yellow,
                    image: DecorationImage(
                        image: AssetImage(widget.image), fit: BoxFit.scaleDown),
                    shape: CircleBorder(),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.name,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 70,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
