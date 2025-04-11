import 'package:flutter/material.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../CommonUi/Input_Fields/labledDatePicker.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';
import '../animalProfiles/animalProfilesList.dart';

class AnimalHealthTwo extends StatefulWidget {
  const AnimalHealthTwo({super.key});

  @override
  State<AnimalHealthTwo> createState() => _AnimalHealthTwoState();
}

class _AnimalHealthTwoState extends State<AnimalHealthTwo> {
  @override
  Widget build(BuildContext context) {
    final ongoing_Health = TextEditingController();
    final current_Weight = TextEditingController();
    final current_size = TextEditingController();
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
                  LabeledTextField(
                    label: 'Ongoing Health Issues',
                    hintText: '',
                    controller: ongoing_Health,
                    lines: 5,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Current Weight',
                    hintText: '',
                    controller: current_Weight,
                    
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Current Size',
                    hintText: '',
                    controller: current_size,
                    
                  ),
                   const Spacer(),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.35,
                    buttonText: 'Save',
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AnimalProfilesList()),
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