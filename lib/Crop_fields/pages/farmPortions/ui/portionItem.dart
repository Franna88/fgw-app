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
  final String portionId;
  final List<Map<String, dynamic>>? rows;
  final String? crop;
  final String? cropFaze;
  final String? dayCount;

  const PortionItem({
    super.key,
    required this.portionName,
    required this.portionType,
    required this.portionId,
    this.rows,
    this.crop,
    this.cropFaze,
    this.dayCount,
  });

  @override
  State<PortionItem> createState() => _PortionItemState();
}

class _PortionItemState extends State<PortionItem> {
  // List to hold crop data for each container
  late List<Map<String, String>> cropData;

  @override
  void initState() {
    super.initState();
    // Initialize crop data
    cropData = [
      {
        'crop': '',
        'cropFaze': '',
        'dayCount': '',
        'rowNumber': '',
        'rows': '0'
      },
      {
        'crop': '',
        'cropFaze': '',
        'dayCount': '',
        'rowNumber': '',
        'rows': '0'
      },
      {
        'crop': '',
        'cropFaze': '',
        'dayCount': '',
        'rowNumber': '',
        'rows': '0'
      },
    ];

    // If we have existing crop data, populate the first container
    if (widget.crop != null && widget.crop!.isNotEmpty) {
      final rowCount = widget.rows?.length ?? 0;
      print('Initializing with row count: $rowCount'); // Debug print
      cropData[0] = {
        'crop': widget.crop ?? '',
        'cropFaze': widget.cropFaze ?? '',
        'dayCount': widget.dayCount ?? '',
        'rowNumber': 'Row 1',
        'rows': rowCount.toString(), // Use actual row count
      };
    }
  }

  // Function to update the crop data
  void updateCropData(int index, String crop, String cropFaze, String dayCount,
      String rowNumber, String rows) {
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
      case 'grain type':
        return FontAwesomeIcons.wheatAwn;
      case 'mixed type':
        return FontAwesomeIcons.seedling;
      default:
        return FontAwesomeIcons.plantWilt;
    }
  }

  // Calculate total rows across all crops
  int get totalRows {
    print('Calculating total rows. Widget rows: ${widget.rows}'); // Debug print
    if (widget.rows != null && widget.rows!.isNotEmpty) {
      final count = widget.rows!.length;
      print('Found $count rows'); // Debug print
      return count;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;

    // For debugging
    print('Rows data: ${widget.rows}');
    print('Total rows: $totalRows');

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
                        Text(
                          '$totalRows Rows', // Will display "3 Rows" for your case
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                            content:
                                Text('Edit portion functionality coming soon'),
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
                                  content: Text(
                                      'Add crop functionality coming soon'),
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
                                  padding:
                                      EdgeInsets.only(right: index < 2 ? 8 : 0),
                                  child: CropPortionItem(
                                    crop: cropData[index]['crop']!,
                                    cropFaze: cropData[index]['cropFaze']!,
                                    dayCount: cropData[index]['dayCount']!,
                                    rowCount: int.tryParse(
                                            cropData[index]['rows']!) ??
                                        0,
                                    progress: 0.0,
                                    portionId: widget.portionId,
                                  ),
                                ).animate().fadeIn(
                                    duration: 300.ms, delay: 100.ms * index);
                              } else {
                                // Show AddCropContainer if data is not available
                                return Padding(
                                  padding:
                                      EdgeInsets.only(right: index < 2 ? 8 : 0),
                                  child: AddCropContainer(
                                    portionId: widget.portionId,
                                    onSave: (crop, cropFaze, dayCount,
                                        rowNumber, rows) {
                                      updateCropData(index, crop, cropFaze,
                                          dayCount, rowNumber, rows);
                                    },
                                  ),
                                ).animate().fadeIn(
                                    duration: 300.ms, delay: 100.ms * index);
                              }
                            }),
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
