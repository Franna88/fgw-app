import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/myutility.dart';

class AnimalProfileItem extends StatefulWidget {
  final String animalImage;
  final String animalName;
  final String animalGender;
  final Function() onTap;
  const AnimalProfileItem(
      {super.key,
      required this.animalImage,
      required this.animalName,
      required this.animalGender, required this.onTap});

  @override
  State<AnimalProfileItem> createState() => _AnimalProfileItemState();
}

class _AnimalProfileItemState extends State<AnimalProfileItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 180,
        width: MyUtility(context).width * 0.40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(widget.animalImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50,
            width: MyUtility(context).width * 0.40,
            decoration: BoxDecoration(
              color: MyColors().black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.animalName,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    size: 35,
                    widget.animalGender == 'male'
                        ? Icons.male
                        : widget.animalGender == 'female'
                            ? Icons.female
                            : Icons.drag_handle,
                    color: widget.animalGender == 'male'
                        ? Colors.blueAccent
                        : widget.animalGender == 'female'
                            ? Colors.deepPurple
                            : Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
