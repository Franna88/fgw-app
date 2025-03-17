import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmSoil.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/Buttons/counterWidget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/myutility.dart';

class FarmToolsCount extends StatefulWidget {
  const FarmToolsCount({super.key});

  @override
  State<FarmToolsCount> createState() => _FarmToolsCountState();
}

class _FarmToolsCountState extends State<FarmToolsCount> {
  final Map<String, int> tools = {
    'Hoe': 0,
    'Trowel': 0,
    'Scythe': 0,
    'Sickle': 0,
    'Shovel': 0,
    'Tractor': 0,

  };

  final Map<String, bool> selectedTools = {
    'Hoe': true,
    'Trowel': false,
    'Scythe': true,
    'Sickle': false,
    'Shovel': true,
    'Tractor': true,
  };

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      header: 'Tools',
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Please Select all tools available on your farm',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MyUtility(context).height * 0.45,
            width: MyUtility(context).width,
            child: ListView(
              children: tools.keys.map((animal) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: selectedTools[animal],
                            onChanged: (bool? value) {
                              setState(() {
                                selectedTools[animal] = value!;
                              });
                            },
                            activeColor: MyColors().black,
                            checkColor: Colors.amber,
                          ),
                          Text(
                            animal,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      CounterWidget(
                        count: tools[animal]!,
                        onChanged: (value) {
                          setState(() {
                            tools[animal] = value;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
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
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FarmSoil()),
  );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
