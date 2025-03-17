import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmType.dart';

import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

class FarmIrrigation extends StatefulWidget {
  const FarmIrrigation({super.key});

  @override
  State<FarmIrrigation> createState() => _FarmIrrigationState();
}

class _FarmIrrigationState extends State<FarmIrrigation> {
  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Irrigation',
      children: [
        const Spacer(),
        Column(
          children: [
            const SizedBox(height: 15),
            LabeledDropdown(
                label: 'Type of Irrigation',
                hintText: '',
                items: [],
                onChanged: (value) {}),
            const SizedBox(height: 15),
            LabeledDropdown(
                label: 'Source of Irrigation Water',
                hintText: '',
                items: [],
                onChanged: (value) {}),
          ],
        ),
        const Spacer(),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Next',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FarmType()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
