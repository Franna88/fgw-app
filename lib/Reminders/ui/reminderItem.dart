import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderItem extends StatelessWidget {
  final String field;
  final String portion;
  final String reminder;
  final String date;
  final bool checkBoxValue;
  final Function(bool?) onChanged;
  const ReminderItem(
      {super.key,
      required this.field,
      required this.portion,
      required this.reminder,
      required this.date,
      required this.checkBoxValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        //height: 300,
        width: MyUtility(context).width * 0.93,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: MyColors().red),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    field,
                    style: GoogleFonts.robotoSlab(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Checkbox(
                    activeColor: MyColors().black,
                    value: checkBoxValue,
                    onChanged: onChanged,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                portion,
                style: GoogleFonts.roboto(fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MyUtility(context).width * 0.93,
                child: Text(
                  reminder,
                  style: GoogleFonts.roboto(fontSize: 17),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                date,
                style:
                    GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
