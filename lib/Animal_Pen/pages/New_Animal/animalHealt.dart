import 'package:farming_gods_way/Animal_Pen/pages/New_Animal/animalHealthTwo.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AnimalHealth extends StatefulWidget {
  const AnimalHealth({super.key});

  @override
  State<AnimalHealth> createState() => _AnimalHealthState();
}

class _AnimalHealthState extends State<AnimalHealth> {
  @override
  Widget build(BuildContext context) {
    final medHistory = TextEditingController();
    final recentTreatments = TextEditingController();
    final vacDate = TextEditingController();
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
                    header: 'Animal Health Records',
                    hasBackArrow: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledDatePicker(
                      label: 'Vaccination date',
                      hintText: '',
                      controller: vacDate),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Medical History',
                    hintText: '',
                    controller: medHistory,
                    lines: 5,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Recent Treatments',
                    hintText: '',
                    controller: recentTreatments,
                    lines: 5,
                  ),
                   const Spacer(),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.35,
                    buttonText: 'Next',
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AnimalHealthTwo()),
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
