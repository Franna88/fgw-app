import 'package:farming_gods_way/Crop_fields/pages/Full_Portion_view/fullPortionView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constants/colors.dart';

class CropPortionItem extends StatelessWidget {
  final String crop;
  final String cropFaze;
  final String dayCount;
  final String rowCount;
  final double progress;
  
  const CropPortionItem({
    super.key,
    required this.crop,
    required this.cropFaze,
    required this.dayCount,
    required this.rowCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    // Determine crop icon based on crop name
    IconData getCropIcon() {
      final cropLower = crop.toLowerCase();
      if (cropLower.contains('carrot')) return FontAwesomeIcons.carrot;
      if (cropLower.contains('spinach') || cropLower.contains('lettuce')) return FontAwesomeIcons.leaf;
      if (cropLower.contains('tomato') || cropLower.contains('apple')) return FontAwesomeIcons.apple;
      if (cropLower.contains('potato')) return FontAwesomeIcons.seedling;
      return FontAwesomeIcons.plantWilt;
    }
    
    // Determine color based on phase
    Color getPhaseColor() {
      final phaseLower = cropFaze.toLowerCase();
      if (phaseLower.contains('harvest')) return myColors.green;
      if (phaseLower.contains('growth')) return myColors.yellow;
      if (phaseLower.contains('plant')) return myColors.lightBlue;
      return Colors.grey[700]!;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FullPortionView()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          height: 170, // Fixed height to prevent overflow
          padding: const EdgeInsets.all(8), // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row number badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: myColors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$rowCount Rows",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 6),
              
              // Crop name with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: myColors.forestGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: FaIcon(
                      getCropIcon(),
                      size: 12,
                      color: myColors.forestGreen,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      crop,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Phase badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: getPhaseColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: getPhaseColor().withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  cropFaze,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: getPhaseColor(),
                  ),
                ),
              ),
              
              const SizedBox(height: 6),
              
              // Progress label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: progress >= 1.0 ? myColors.green : myColors.yellow,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 3),
              
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 ? myColors.green : myColors.yellow,
                  ),
                ),
              ),
              
              const SizedBox(height: 6),
              
              // Day count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      size: 8,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dayCount,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
