import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Crop_fields/pages/Create_Portion/ui/portionInfo.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AddCrop extends StatefulWidget {
  const AddCrop({super.key});

  @override
  State<AddCrop> createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _cropFazeController = TextEditingController();
  final TextEditingController _dayCountController = TextEditingController();
  final TextEditingController _rowNumberController = TextEditingController();

  String? _selectedPortion;
  String? _selectedRows;
  String? _selectedCrop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(
              height: MyUtility(context).height * 0.05,
            ),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    MyColors().forestGreen,
                    MyColors().lightGreen,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  CornerHeaderContainer(
                    header: 'New Portions',
                    hasBackArrow: true,
                  ),
                  const SizedBox(height: 20),
                  LabeledDropdown(
                    label: 'Portion',
                    hintText: '',
                    items: ['Portion B'],
                    onChanged: (value) {
                      setState(() {
                        _selectedPortion = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '*Current Portion type for Portion A',
                    style: GoogleFonts.roboto(
                      letterSpacing: 1.1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LabeledDropdown(
                    label: 'Number of Rows',
                    hintText: '',
                    items: ['5'],
                    onChanged: (value) {
                      setState(() {
                        _selectedRows = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  LabeledDropdown(
                    label: 'Crop',
                    hintText: '',
                    items: [
                      'Carrot',
                      'Potatoes',
                      'Beetroot',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCrop = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 160,
                    width: MyUtility(context).width * 0.90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors().offWhite,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          PortionInfo(
                              text: 'Estimated harvest amount',
                              amounts: '55 plants'),
                          PortionInfo(text: 'Planting Depth', amounts: '3 cm'),
                          PortionInfo(
                              text: 'Distance in row', amounts: '12 cm'),
                          PortionInfo(
                              text: 'Distance between row', amounts: '12 cm'),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.40,
                    buttonText: 'Save',
                    onTap: () {
                      Navigator.pop(context, {
                        'portion': _selectedPortion,
                        'rows': _selectedRows,
                        'crop': _selectedCrop,
                        'cropFaze': _cropFazeController.text,
                        'dayCount': _dayCountController.text,
                        'rowNumber': _rowNumberController.text,
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cropController.dispose();
    _cropFazeController.dispose();
    _dayCountController.dispose();
    _rowNumberController.dispose();
    super.dispose();
  }
}
