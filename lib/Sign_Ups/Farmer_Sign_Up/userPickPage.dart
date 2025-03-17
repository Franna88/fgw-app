import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/pages/farmerSignUpStepOne.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:farming_gods_way/Sign_Ups/Worker_Registration/workerSignUpStepOne.dart';
import 'package:flutter/material.dart';

class UserPickPage extends StatelessWidget {
  const UserPickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      customHight: MyUtility(context).height * 0.70,
      header: 'Sign Up',
      children: [
        const Spacer(),
        CommonButton(
          customWidth: MyUtility(context).width * 0.85,
          styleTwo: true,
          buttonText: 'Farmer Sign Up',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FarmerSignUpStepOne()),
            );
          },
        ),
        SizedBox(
          height: MyUtility(context).height * 0.05,
        ),
        CommonButton(
          customWidth: MyUtility(context).width * 0.85,
          styleTwo: true,
          buttonText: 'Worker Sign Up',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkerSignUpStepOne(),
              ),
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
