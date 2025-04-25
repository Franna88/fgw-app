import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/myutility.dart';

class FieldTaskBoardItem extends StatelessWidget {
  final String row;
  final String tasksComplete;
  final String faze;
  final double progressValue;
  final bool isImportant;
  final VoidCallback onTap;

  const FieldTaskBoardItem({
    super.key,
    required this.row,
    required this.tasksComplete,
    required this.faze,
    required this.progressValue,
    required this.isImportant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    // Determine color based on completion value
    Color progressColor = myColors.lightGreen;
    if (progressValue >= 1.0) {
      progressColor = myColors.green;
    } else if (progressValue > 0.5) {
      progressColor = myColors.yellow;
    } else if (progressValue > 0) {
      progressColor = myColors.yellow;
    } else {
      progressColor = myColors.brightRed;
    }
    
    // Determine stage icon
    IconData stageIcon = FontAwesomeIcons.seedling;
    if (faze.toLowerCase().contains('grow')) {
      stageIcon = FontAwesomeIcons.leaf;
    } else if (faze.toLowerCase().contains('harvest')) {
      stageIcon = FontAwesomeIcons.handHoldingHeart;
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              // Priority indicator
              if (isImportant)
                Container(
                  height: 3,
                  width: double.infinity,
                  color: myColors.brightRed,
                ),
                
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row and completion info
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: progressValue >= 1.0 
                                ? myColors.green.withOpacity(0.1) 
                                : myColors.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: progressValue >= 1.0 
                                  ? myColors.green 
                                  : myColors.yellow,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tasksComplete,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: progressValue >= 1.0 
                                  ? myColors.green 
                                  : myColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Stage/phase information
                    Row(
                      children: [
                        FaIcon(
                          stageIcon,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          faze,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Progress indicator
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                    
                    if (isImportant)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 14,
                              color: myColors.brightRed,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'High Priority',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: myColors.brightRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, duration: 300.ms);
  }
}
