import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReminderItem extends StatelessWidget {
  final String field;
  final String portion;
  final String reminder;
  final DateTime date;
  final bool checkBoxValue;
  final Function(bool?)? onChanged;

  const ReminderItem({
    super.key,
    required this.field,
    required this.portion,
    required this.reminder,
    required this.date,
    required this.checkBoxValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(date);
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        portion,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: checkBoxValue,
                  onChanged: onChanged,
                  activeColor: myColors.forestGreen,
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              reminder,
              style: GoogleFonts.roboto(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: myColors.forestGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formattedDate,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: difference < 0
                        ? Colors.red[50]
                        : difference == 0
                            ? Colors.orange[50]
                            : Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    difference < 0
                        ? 'Overdue'
                        : difference == 0
                            ? 'Due today'
                            : '$difference days left',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: difference < 0
                          ? Colors.red
                          : difference == 0
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
