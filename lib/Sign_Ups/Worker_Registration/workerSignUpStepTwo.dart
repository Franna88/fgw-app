import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Sign_Ups/Worker_Registration/workerFarmerSearch.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../Constants/myutility.dart';
import '../Farmer_Sign_Up/ui/signUpStructure.dart';

class WorkerSignUpStepTwo extends StatefulWidget {
  const WorkerSignUpStepTwo({super.key});

  @override
  State<WorkerSignUpStepTwo> createState() => _WorkerSignUpStepTwoState();
}

class _WorkerSignUpStepTwoState extends State<WorkerSignUpStepTwo> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController birthDate = TextEditingController();
  final TextEditingController homeLanguage = TextEditingController();
  final TextEditingController proficiencyEnglish = TextEditingController();

  String? selectedGender;

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
      isScrollable: true,
      header: 'Worker Sign Up',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Date of Birth',
                hintText: '',
                controller: birthDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of Birth is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              LabeledDropdown(
                label: 'Gender',
                hintText: 'Select gender',
                items: ['Male', 'Female'],
                value: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Home Language',
                hintText: '',
                controller: homeLanguage,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Home Language is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Level of Proficiency in English',
                hintText: '',
                controller: proficiencyEnglish,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proficiency level is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        //const Spacer(),
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
                    builder: (context) => const WorkerFarmerSearch()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
