import 'package:farming_gods_way/CommonUi/Input_Fields/mySearchBarWidget.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Login/login.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:farming_gods_way/Sign_Ups/Worker_Registration/ui/farmerRequestItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';

class WorkerFarmerSearch extends StatefulWidget {
  const WorkerFarmerSearch({super.key});

  @override
  State<WorkerFarmerSearch> createState() => _WorkerFarmerSearchState();
}

class _WorkerFarmerSearchState extends State<WorkerFarmerSearch> {
  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Search Farmer',
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          'Search for Your farmer and request access to view the farm workboard',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 13),
        ),
        SizedBox(
          height: MyUtility(context).height * 0.05,
        ),
        MySearchBarWidget(),
        SizedBox(
          height: MyUtility(context).height * 0.05,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FarmerRequestItem(
              farmerName: 'Eric Bester',
              farmerImage: 'images/userImage.png',
              farmerEmail: 'EricBester@gmail.com',
              farmerNumber: '082 444 332',
              onTap: () {}),
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
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
