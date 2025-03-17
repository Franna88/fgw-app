import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/pages/farmerSignUpStepFour.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

import '../../../Constants/myutility.dart';

class FarmerSignUpStepThree extends StatefulWidget {
  const FarmerSignUpStepThree({super.key});

  @override
  State<FarmerSignUpStepThree> createState() => _FarmerSignUpStepThreeState();
}

class _FarmerSignUpStepThreeState extends State<FarmerSignUpStepThree> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController country = TextEditingController();
  final TextEditingController province = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController homeAddress = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proceed to the next step
      print("Form is valid. Proceeding...");
    } else {
      print("Form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      header: 'Farmer Sign Up',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Country',
                hintText: '',
                controller: country,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Province',
                hintText: '',
                controller: province,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Province is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'District',
                hintText: '',
                controller: district,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'District is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Home Address',
                hintText: '',
                controller: homeAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Home Address is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        SizedBox(height: MyUtility(context).height * 0.05),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Next',
            onTap: () {
              _submitForm;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FarmerSignUpStepFour()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
