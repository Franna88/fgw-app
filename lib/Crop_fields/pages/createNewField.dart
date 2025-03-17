import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class CreateNewField extends StatefulWidget {
  const CreateNewField({super.key});

  @override
  State<CreateNewField> createState() => _CreateNewFieldState();
}

class _CreateNewFieldState extends State<CreateNewField> {
  final TextEditingController fieldNameController = TextEditingController();

  void _saveField() {
    final field = {
      'name': fieldNameController.text,
      'image': 'images/cropField.png',
    };
    Navigator.pop(context, field);
  }

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
                    colors: [MyColors().forestGreen, MyColors().lightGreen]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  CornerHeaderContainer(
                    header: 'New Field',
                    hasBackArrow: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Field Name',
                    hintText: '',
                    controller: fieldNameController,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MyUtility(context).width * 0.90,
                    child: Text(
                      'Add Reference Image to Task (Optional)',
                      style: GoogleFonts.roboto(
                        letterSpacing: 1.1,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: MyUtility(context).height * 0.25,
                    width: MyUtility(context).width * 0.90,
                    decoration: BoxDecoration(
                      color: MyColors().offWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 35,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.35,
                    buttonText: 'Save',
                    onTap: _saveField,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
