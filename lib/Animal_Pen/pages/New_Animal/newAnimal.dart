import 'package:farming_gods_way/Animal_Pen/pages/New_Animal/animalHealt.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class NewAnimal extends StatefulWidget {
  const NewAnimal({super.key});

  @override
  State<NewAnimal> createState() => _NewAnimalState();
}

class _NewAnimalState extends State<NewAnimal> {
  @override
  Widget build(BuildContext context) {
    final animalName = TextEditingController();
    final animalAge = TextEditingController();
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
                    header: 'New Animal',
                    hasBackArrow: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Animal Name',
                    hintText: '',
                    controller: animalName,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledDropdown(
                      label: 'Gender',
                      hintText: '',
                      items: ['male', 'female'],
                      onChanged: (value) {}),
                       const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Animal Age',
                    hintText: '',
                    controller: animalAge,
                  ),
                 
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MyUtility(context).width * 0.90,
                    child: Text(
                      'Add a photo of this animal',
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
                    buttonText: 'Next',
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AnimalHealth()),
                          );
                    },
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
