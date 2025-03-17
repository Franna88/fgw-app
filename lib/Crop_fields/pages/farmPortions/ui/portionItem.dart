import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    {'crop': '', 'cropFaze': '', 'dayCount': '', 'rowNumber': ''},
    {'crop': '', 'cropFaze': '', 'dayCount': '', 'rowNumber': ''},
    {'crop': '', 'cropFaze': '', 'dayCount': '', 'rowNumber': ''},
  ];

  // Function to update the crop data
  void updateCropData(int index, String crop, String cropFaze, String dayCount, String rowNumber) {
    setState(() {
      cropData[index] = {
        'crop': crop,
        'cropFaze': cropFaze,
        'dayCount': dayCount,
        'rowNumber': rowNumber,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        width: MyUtility(context).width * 0.90,
        height: 300,
        decoration: BoxDecoration(
          color: MyColors().lightGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 55,
                width: MyUtility(context).width * 0.90 - 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    const Spacer(),
                    Text(
                      widget.portionName,
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 221,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                        ),
                        const Spacer(),
                        Transform.rotate(
                          angle: -1.55,
                          child: Container(
                            child: Text(
                              widget.portionType,
                              style: GoogleFonts.roboto(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    height: 221,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) {
                        // Check if data is available for this crop container
                        if (cropData[index]['crop'] != '') {
                          // Replace AddCropContainer with CropPortionItem when data is available
                          return CropPortionItem(
                            crop: cropData[index]['crop']!,
                            cropFaze: cropData[index]['cropFaze']!,
                            dayCount: cropData[index]['dayCount']!,
                            rowNumber: cropData[index]['rowNumber']!,
                            progress: 0.8, // You can adjust the progress value
                          );
                        } else {
                          // Show AddCropContainer if data is not available
                          return AddCropContainer(
                            onSave: (crop, cropFaze, dayCount, rowNumber) {
                              updateCropData(
                                  index, crop, cropFaze, dayCount, rowNumber);
                            },
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
