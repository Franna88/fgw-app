import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Tasks/ui/importantStatusItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksFieldsDisplayItem extends StatelessWidget {
  final Function() onTap;
  const TasksFieldsDisplayItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 130,
        width: MyUtility(context).width * 0.85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Field A',
                    style: GoogleFonts.roboto(
                        fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  ImportantStatusItem()
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Portion B',
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MyUtility(context).width * 0.85 - 80,
                    child: LinearProgressIndicator(
                      value: 0.4,
                      minHeight: 12,
                      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 95, 199, 98),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    '2/6',
                    style: GoogleFonts.roboto(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
