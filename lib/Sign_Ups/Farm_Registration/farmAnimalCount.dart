import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/Buttons/counterWidget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/myutility.dart';

class FarmAnimalCount extends StatefulWidget {
  const FarmAnimalCount({super.key});

  @override
  State<FarmAnimalCount> createState() => _FarmAnimalCountState();
}

class _FarmAnimalCountState extends State<FarmAnimalCount> {
  final Map<String, int> animals = {
    'Chickens': 0,
    'Cattle': 0,
    'Goats': 0,
    'Ducks': 0,
    'Sheep': 0,
  };

  final Map<String, bool> selectedAnimals = {
    'Chickens': true,
    'Cattle': false,
    'Goats': true,
    'Ducks': false,
    'Sheep': true,
  };

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      header: 'Animals',
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Please Select and fill all animals on your farm',
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
              children: animals.keys.map((animal) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: selectedAnimals[animal],
                            onChanged: (bool? value) {
                              setState(() {
                                selectedAnimals[animal] = value!;
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
                        count: animals[animal]!,
                        onChanged: (value) {
                          setState(() {
                            animals[animal] = value;
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
            onTap: () {},
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
