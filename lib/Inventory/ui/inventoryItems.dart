import 'package:farming_gods_way/CommonUi/Buttons/counterWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class InventoryItems extends StatefulWidget {
  final String image;
  final String name;
  final int count;
  final ValueChanged<int> onChanged;
  const InventoryItems(
      {super.key,
      required this.image,
      required this.name,
      required this.count,
      required this.onChanged});

  @override
  State<InventoryItems> createState() => _InventoryItemsState();
}

class _InventoryItemsState extends State<InventoryItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: 120,
        width: MyUtility(context).width,
        decoration: BoxDecoration(
          color: MyColors().offWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: AssetImage(widget.image), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  CounterWidget(count: widget.count, onChanged: widget.onChanged)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
