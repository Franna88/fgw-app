import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myTextButton.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/pages/farmerSignUpStepTwo.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

import '../../../Constants/myutility.dart';

class FarmerSignUpStepOne extends StatefulWidget {
  const FarmerSignUpStepOne({super.key});

  @override
  State<FarmerSignUpStepOne> createState() => _FarmerSignUpStepOneState();
}

class _FarmerSignUpStepOneState extends State<FarmerSignUpStepOne> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController idPassportController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  String? _validateIdPassport(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID/Passport number is required';
    }
    if (value.length < 6) {
      return 'ID/Passport number is too short';
    }
    return null;
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      // Proceed to next step if validation is successful
      print("Form is valid, navigating to next step...");
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
                label: 'Email',
                hintText: '@',
                controller: emailController,
                validator: _validateEmail,
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'First Name',
                hintText: '',
                controller: firstNameController,
                validator: (value) => _validateNotEmpty(value, 'First Name'),
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Last Name',
                hintText: '',
                controller: lastNameController,
                validator: (value) => _validateNotEmpty(value, 'Last Name'),
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'ID/Passport Number',
                hintText: '',
                controller: idPassportController,
                validator: _validateIdPassport,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: MyTextButton(
            text: 'Please provide Photo of ID/Passport',
            underline: true,
            onTap: () {},
          ),
        ),
        SizedBox(
          height: MyUtility(context).height * 0.05,
        ),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Next',
            onTap: () {
              _onNextPressed;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FarmerSignUpStepTwo()),
              );
            },
          ),
        ),
        const SizedBox(height: 20), // Give some space instead of Spacer()
      ],
    );
  }
}
