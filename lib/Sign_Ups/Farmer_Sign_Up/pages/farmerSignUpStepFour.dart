import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmLoaction.dart';

import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';



class FarmerSignUpStepFour extends StatefulWidget {
  const FarmerSignUpStepFour({super.key});

  @override
  State<FarmerSignUpStepFour> createState() => _FarmerSignUpStepFourState();
}

class _FarmerSignUpStepFourState extends State<FarmerSignUpStepFour> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController farmExp = TextEditingController();
  final TextEditingController numberFarms = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Farmer Sign Up',
      children: [
        const Spacer(),
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Total Farming Experience',
                hintText: '',
                controller: farmExp,
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Number of Farms',
                hintText: '',
                controller: numberFarms,
              ),
            ],
          ),
        ),

        const Spacer(),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Next',
            onTap: () {
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FarmLocation()),
  );
            },
          ),
        ),
        const SizedBox(height: 20), // Give some space instead of Spacer()
      ],
    );
  }
}
