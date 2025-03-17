import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmToolsCount.dart';

import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

import '../../Constants/myutility.dart';

class FarmType extends StatefulWidget {
  const FarmType({super.key});

  @override
  State<FarmType> createState() => _FarmTypeState();
}

class _FarmTypeState extends State<FarmType> {
  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Farm Type',
      children: [
        const Spacer(),
        Column(
          children: [
            const SizedBox(height: 15),
            LabeledDropdown(
                label: 'Type of Farm',
                hintText: '',
                items: [],
                onChanged: (value) {}),
            const SizedBox(height: 15),
            LabeledDropdown(
                label: 'Farm Production Type',
                hintText: '',
                items: [],
                onChanged: (value) {}),
            const SizedBox(height: 15),
            LabeledDropdown(
                label: 'Orientation of Rows',
                hintText: '',
                items: [],
                onChanged: (value) {}),
            const SizedBox(height: 15),
            LabeledDropdown(
                label: 'General Ground Slope',
                hintText: '',
                items: [],
                onChanged: (value) {}),
          ],
        ),
        const Spacer(),
        SizedBox(
          height: MyUtility(context).height * 0.05,
        ),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Next',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FarmToolsCount()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
