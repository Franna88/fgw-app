import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constants/myutility.dart';

class PortionRowTaskItem extends StatelessWidget {
  final String row;
  final double progressValue;
  final String rowFaze;
  final Function() onTap;
  
  const PortionRowTaskItem({
    super.key,
    required this.row,
    required this.progressValue,
    required this.rowFaze,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    // Determine color based on completion value and phase
    Color progressColor;
    IconData statusIcon;
    
    if (progressValue >= 1.0) {
      progressColor = myColors.green;
      statusIcon = FontAwesomeIcons.check;
    } else if (progressValue > 0.5) {
      progressColor = myColors.yellow;
      statusIcon = FontAwesomeIcons.spinner;
    } else if (progressValue > 0) {
      progressColor = myColors.lightBlue;
      statusIcon = FontAwesomeIcons.arrowsTurnRight;
    } else {
      progressColor = Colors.grey;
      statusIcon = FontAwesomeIcons.clockRotateLeft;
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row header with action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: myColors.lightGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 16,
                          color: myColors.forestGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        row,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 18, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: progressColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        statusIcon,
                        color: progressColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Phase badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rowFaze,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: progressColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Progress percentage
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(progressValue * 100).toInt()}%',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
