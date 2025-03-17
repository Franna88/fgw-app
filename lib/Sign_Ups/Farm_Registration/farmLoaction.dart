import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmMap.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

class FarmLocation extends StatefulWidget {
  const FarmLocation({super.key});

  @override
  State<FarmLocation> createState() => _FarmLocationState();
}

class _FarmLocationState extends State<FarmLocation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController location = TextEditingController();
  final TextEditingController address = TextEditingController();

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Farm Registration',
      children: [
        const Spacer(),
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Farm Location',
                hintText: '',
                controller: location,
                validator: _validateField,
              ),
              const SizedBox(height: 15),
              LabeledTextField(
                label: 'Farm Address',
                hintText: '',
                controller: address,
                validator: _validateField,
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
              if (_formKey.currentState!.validate()) {}
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FarmMap()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
