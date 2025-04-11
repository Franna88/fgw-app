import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class NewAnimalField extends StatefulWidget {
  const NewAnimalField({super.key});

  @override
  State<NewAnimalField> createState() => _NewAnimalFieldState();
}

class _NewAnimalFieldState extends State<NewAnimalField> {
  final TextEditingController fieldNameController = TextEditingController();
  String? selectedAnimal;

  String _getAnimalImage(String animal) {
    switch (animal) {
      case 'Sheep':
        return 'images/sheep.png';
      case 'Cattle':
        return 'images/cattle.png';
      case 'Pigs':
        return 'images/pig.png';
      case 'Chickens':
        return 'images/chicken.png';
      default:
        return 'images/livestock.png';
    }
  }

  void _saveField() {
    if (fieldNameController.text.isEmpty || selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all the required details.')),
      );
      return;
    }

    Navigator.pop(context, {
      'name': fieldNameController.text,
      'animal': selectedAnimal!,
      'image': _getAnimalImage(selectedAnimal!),
    });
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const CornerHeaderContainer(
                      header: 'New Field', hasBackArrow: true),
                  const SizedBox(height: 15),
                  LabeledTextField(
                    label: 'Field Name',
                    hintText: '',
                    controller: fieldNameController,
                  ),
                  const SizedBox(height: 15),
                  LabeledDropdown(
                    label: 'Animal',
                    hintText: '',
                    items: ['Sheep', 'Cattle', 'Pigs', 'Chickens'],
                    onChanged: (value) {
                      setState(() {
                        selectedAnimal = value;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
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
                      child: Icon(Icons.image_outlined, size: 35),
                    ),
                  ),
                  const Spacer(),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.35,
                    buttonText: 'Save',
                    onTap: _saveField,
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
