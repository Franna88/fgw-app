import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/myutility.dart';
import 'addCropContainer.dart';
import 'cropPortionItem.dart';

class PortionItem extends StatefulWidget {
  final String portionName;
  final String portionType;

  const PortionItem({
    super.key,
    required this.portionName,
    required this.portionType,
  });

  @override
  State<PortionItem> createState() => _PortionItemState();
}

class _PortionItemState extends State<PortionItem> {
  // List to hold crop data for each container
  List<Map<String, String>> cropData = [
    {'crop': '', 'cropFaze': '', 'dayCount': '', 'rowNumber': '', 'rows': ''},
    {'crop': '', 'cropFaze': '', 'dayCount': '', 'rowNumber': '', 'rows': ''},
    {'crop': '', 'cropFaze': '', 'dayCount': '', 'rowNumber': '', 'rows': ''},
  ];

  // Function to update the crop data
  void updateCropData(int index, String crop, String cropFaze, String dayCount, String rowNumber, String rows) {
    setState(() {
      cropData[index] = {
        'crop': crop,
        'cropFaze': cropFaze,
        'dayCount': dayCount,
        'rowNumber': rowNumber,
        'rows': rows,
      };
      
      // For debugging
      print('Updated crop data at index $index with rows: $rows');
      print('All crop data: $cropData');
    });
  }
  
  // Get the appropriate icon for portion type
  IconData get _portionTypeIcon {
    switch (widget.portionType.toLowerCase()) {
      case 'root type':
        return FontAwesomeIcons.carrot;
      case 'leaf type':
        return FontAwesomeIcons.leaf;
      case 'fruit type':
        return FontAwesomeIcons.apple;
      default:
        return FontAwesomeIcons.plantWilt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate total rows across all crops
    int totalRows = 0;
    bool hasAnyRows = false;
    
    for (var crop in cropData) {
      if (crop['rows'] != null && crop['rows']!.isNotEmpty) {
        hasAnyRows = true;
        totalRows += int.tryParse(crop['rows']!) ?? 0;
      }
    }
    
    // For debugging
    print('Has any rows: $hasAnyRows, Total rows: $totalRows');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: myColors.lightGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: myColors.lightGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: myColors.forestGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        _portionTypeIcon,
                        size: 16,
                        color: myColors.forestGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.portionName,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // Display the total row count if any crop has rows information
                        if (hasAnyRows && totalRows > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.layerGroup,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$totalRows Rows',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, 
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: myColors.lightGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: myColors.lightGreen.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.portionType,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: myColors.forestGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        // Edit portion functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Edit portion functionality coming soon'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: myColors.forestGreen,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: myColors.forestGreen,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Crops section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Side bar
                    Container(
                      width: 50,
                      height: 170, // Match the height of CropPortionItem
                      decoration: BoxDecoration(
                        color: myColors.lightGreen.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: myColors.lightGreen.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Add new crop functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Add crop functionality coming soon'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: myColors.forestGreen,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.add,
                              color: myColors.forestGreen,
                            ),
                            tooltip: 'Add new crop',
                          ),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              widget.portionType,
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: myColors.forestGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Crops list
                    Expanded(
                      child: SizedBox(
                        height: 170, // Match height of CropPortionItem
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3, // Fixed to 3 crops for now
                          itemBuilder: (context, index) {
                            // Check if data is available for this crop container
                            if (cropData[index]['crop']!.isNotEmpty) {
                              // Replace AddCropContainer with CropPortionItem when data is available
                              return Padding(
                                padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
                                child: CropPortionItem(
                                  crop: cropData[index]['crop']!,
                                  cropFaze: cropData[index]['cropFaze']!,
                                  dayCount: cropData[index]['dayCount']!,
                                  rowCount: cropData[index]['rows']!,
                                  progress: 0.8, // You can adjust the progress value
                                ),
                              ).animate().fadeIn(duration: 300.ms, delay: 100.ms * index);
                            } else {
                              // Show AddCropContainer if data is not available
                              return Padding(
                                padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
                                child: AddCropContainer(
                                  onSave: (crop, cropFaze, dayCount, rowNumber, rows) {
                                    updateCropData(
                                      index, crop, cropFaze, dayCount, rowNumber, rows);
                                  },
                                ),
                              ).animate().fadeIn(duration: 300.ms, delay: 100.ms * index);
                            }
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
