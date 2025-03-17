import 'package:farming_gods_way/CommonUi/Buttons/counterWidget.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Login/login.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';

class FarmWorkers extends StatefulWidget {
  const FarmWorkers({super.key});

  @override
  State<FarmWorkers> createState() => _FarmWorkersState();
}

class _FarmWorkersState extends State<FarmWorkers> {
  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Workers',
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 15, top: 10),
          child: Text(
            'Number of Available Workers',
            style: GoogleFonts.roboto(
              letterSpacing: 1.1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CounterWidget(count: 0, onChanged: (value) {}),
        ),
        const SizedBox(
          height: 15,
        ),
        LabeledDropdown(
          label: 'Average Experience of Workers',
          hintText: '',
          items: [],
          onChanged: (value) {},
        ),
        const Spacer(),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Done',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
