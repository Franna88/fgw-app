import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmIrrigation.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../Constants/myutility.dart';

class FarmMap extends StatefulWidget {
  const FarmMap({super.key});

  @override
  State<FarmMap> createState() => _FarmMapState();
}

class _FarmMapState extends State<FarmMap> {
  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Farm Registration',
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Is this your farm?',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(
          height: MyUtility(context).height * 0.02,
        ),
        Container(
          width: MyUtility(context).width * 0.93,
          height: MyUtility(context).height * 0.48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: MyColors().offWhite),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: AssetImage('images/mapsPlaceholder.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Next',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FarmIrrigation()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
