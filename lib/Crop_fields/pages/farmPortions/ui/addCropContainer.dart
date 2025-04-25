import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constants/colors.dart';
import '../../Create_Portion/addCrop.dart';

class AddCropContainer extends StatelessWidget {
  final Function(String crop, String cropFaze, String dayCount, String rowNumber, String rows) onSave;

  const AddCropContainer({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          // Navigate to AddCrop page and wait for the user input
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCrop()),
          );

          if (result != null) {
            // Pass the result back to the parent widget (PortionItem)
            onSave(
              result['crop'] ?? '', 
              result['cropFaze'] ?? '', 
              result['dayCount'] ?? '', 
              result['rowNumber'] ?? '',
              result['rows'] ?? '',
            );
            
            // For debugging - print out the values to ensure rows is being passed
            print('Saved crop with rows: ${result['rows']}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          height: 170, // Match the height of CropPortionItem
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: myColors.lightGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: myColors.forestGreen.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    size: 20,
                    color: myColors.forestGreen,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add Crop',
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: myColors.forestGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to add a new crop to this portion',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}