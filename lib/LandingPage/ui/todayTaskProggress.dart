import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayTaskProggress extends StatefulWidget {
  const TodayTaskProggress({super.key});

  @override
  State<TodayTaskProggress> createState() => _TodayTaskProggressState();
}

class _TodayTaskProggressState extends State<TodayTaskProggress> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final completedTasks = 3;
    final totalTasks = 10;
    final progressValue = completedTasks / totalTasks;
    
    return Container(
      width: MyUtility(context).width * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: myColors.yellow,
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: myColors.black,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Task Progress',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: myColors.black,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completed: $completedTasks of $totalTasks',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: progressValue >= 1.0 
                          ? myColors.green 
                          : (progressValue > 0.5 ? myColors.yellow : myColors.lightGreen),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${(progressValue * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: progressValue >= 1.0 ? Colors.white : myColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Progress bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Background
                        Container(
                          width: constraints.maxWidth,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        
                        // Progress
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutQuad,
                          width: constraints.maxWidth * progressValue,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _getProgressColor(progressValue),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                _getProgressColor(progressValue),
                                _getProgressColor(progressValue).withOpacity(0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideX(
                              begin: -0.2,
                              end: 0,
                              duration: 800.ms,
                              curve: Curves.easeOutQuad,
                            ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 12),
                
                // View all tasks button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigate to tasks page
                    },
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: myColors.forestGreen,
                    ),
                    label: Text(
                      'View all tasks',
                      style: TextStyle(
                        color: myColors.forestGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getProgressColor(double value) {
    final myColors = MyColors();
    if (value >= 1.0) return myColors.green;
    if (value > 0.6) return myColors.lightGreen;
    if (value > 0.3) return myColors.yellow;
    return myColors.red;
  }
}
