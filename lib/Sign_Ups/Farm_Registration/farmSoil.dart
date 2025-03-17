import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmWorkers.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class FarmSoil extends StatefulWidget {
  const FarmSoil({super.key});

  @override
  State<FarmSoil> createState() => _FarmSoilState();
}

class _FarmSoilState extends State<FarmSoil> {
  final Map<String, bool> soil = {
    'Characteristics0 ': true,
    'Characteristics1': false,
    'Characteristics2': true,
    'Characteristics3': false,
    'Characteristics4': true,
    'Characteristics5': true,
  };

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      header: 'Farm Soil',
      children: [
        const SizedBox(
          height: 10,
        ),
        LabeledDropdown(
            label: 'Type of Soil',
            hintText: '',
            items: [],
            onChanged: (value) {}),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Soil Characteristics',
            style: GoogleFonts.roboto(
              letterSpacing: 1.1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MyUtility(context).height * 0.43,
            width: MyUtility(context).width,
            child: ListView(
              children: soil.keys.map((animal) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: soil[animal],
                        onChanged: (bool? value) {
                          setState(() {
                            soil[animal] = value!;
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
                );
              }).toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CommonButton(
              customWidth: 120,
              buttonText: 'Next',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmWorkers()),
                );
              }),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
