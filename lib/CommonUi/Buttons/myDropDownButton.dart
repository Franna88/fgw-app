import 'package:farming_gods_way/Constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDropDownButton extends StatefulWidget {
  final List<String> items;
  final double customWidth;
  final ValueChanged<dynamic> onChanged;
  final String? value;
  const MyDropDownButton(
      {super.key,
      required this.items,
      required this.customWidth,
      required this.onChanged,
      this.value});

  @override
  State<MyDropDownButton> createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  String? selectedValue;
  String? errorText;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.customWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: MyColors().lightBlue),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: DropdownButton(
          dropdownColor: Colors.white,
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged(value);
          },
          hint: Text(
            'Month',
            style: GoogleFonts.robotoSlab(),
          ),
        ),
      ),
    );
  }
}
