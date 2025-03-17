import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class NewPortion extends StatefulWidget {
  const NewPortion({super.key});

  @override
  State createState() => _NewPortionState();
}

class _NewPortionState extends State<NewPortion> {
  final TextEditingController _rowLengthController = TextEditingController();
  String? _selectedPortion;
  String? _selectedPortionType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColors().forestGreen, MyColors().lightGreen],
                ),
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const CornerHeaderContainer(
                      header: 'New Portion', hasBackArrow: true),
                  const SizedBox(height: 20),
                  LabeledDropdown(
                    label: 'Select Portion',
                    hintText: 'Select Portion',
                    items: ['Portion A', 'Portion B', 'Portion C'],
                    value: _selectedPortion,
                    onChanged: (value) {
                      setState(() {
                        _selectedPortion = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: 'Row Length',
                    hintText: 'Enter row length',
                    controller: _rowLengthController,
                  ),
                  const SizedBox(height: 20),
                  LabeledDropdown(
                    label: 'Select Portion Type',
                    hintText: 'Select Portion Type',
                    items: ['Leaf type', 'Root type', 'Fruit type'],
                    value: _selectedPortionType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPortionType = value;
                      });
                    },
                  ),
                  const Spacer(),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.40,
                    buttonText: 'Next',
                    onTap: () {
                      if (_selectedPortion != null &&
                          _rowLengthController.text.isNotEmpty &&
                          _selectedPortionType != null) {
                        Navigator.pop(context, {
                          'portionName': _selectedPortion,
                          'rowLength': _rowLengthController.text,
                          'portionType': _selectedPortionType,
                        });
                      }
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
}
