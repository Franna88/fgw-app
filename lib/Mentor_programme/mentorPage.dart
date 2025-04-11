import 'package:farming_gods_way/Animal_Pen/animalFields.dart';
import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Inventory/inventory.dart';
import 'package:farming_gods_way/Mentor_programme/pages/mentorNotes.dart';
import 'package:farming_gods_way/Mentor_programme/ui/farmerDataBlock.dart';
import 'package:farming_gods_way/Mentor_programme/ui/userBlock.dart';
import 'package:farming_gods_way/Tasks/tasksHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Crop_fields/cropFields.dart';

class MentorPage extends StatefulWidget {
  const MentorPage({super.key});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FgwTopBar(),
                SizedBox(height: 15),
                CornerHeaderContainer(
                  header: 'Mentor Programme',
                  hasBackArrow: false,
                ),
                SizedBox(height: 15),
                UserBlock(
                    userImage: 'images/userImage.png', userName: 'Eric Bester'),
                SizedBox(height: 15),
                FarmerDataBlock(
                    age: '45',
                    country: 'country',
                    yearsExp: '3',
                    province: 'province',
                    fgwExp: '2',
                    city: 'city',
                    englishProf: '3'),
                SizedBox(height: 15),
                CornerHeaderContainer(
                  header: 'Farm Name',
                  hasBackArrow: false,
                ),
                SizedBox(height: 15),
                Container(
                  width: MyUtility(context).width,
                  height: MyUtility(context).height * 0.30,
                  decoration: BoxDecoration(
                      color: MyColors().black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    //Maps Placeholder
                    child: Image.asset('images/mapsPlaceholder.png'),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: MyUtility(context).width,
                  decoration: BoxDecoration(
                    color: MyColors().black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: MyUtility(context).width * 0.50 - 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Crop Farm',
                                  style: GoogleFonts.roboto(),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: MyUtility(context).width * 0.50 - 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Irrigation : Hose',
                                  style: GoogleFonts.roboto(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                CommonButton(
                    customWidth: MyUtility(context).width,
                    buttonText: 'View Task Board',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TasksHome(),
                        ),
                      );
                    }),
                SizedBox(height: 15),
                CommonButton(
                    customWidth: MyUtility(context).width,
                    buttonText: 'View Crop Fields',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CropFields(),
                        ),
                      );
                    }),
                SizedBox(height: 15),
                CommonButton(
                    customWidth: MyUtility(context).width,
                    buttonText: 'View Animal Fields',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnimalFields(),
                        ),
                      );
                    }),
                SizedBox(height: 15),
                CommonButton(
                    customWidth: MyUtility(context).width,
                    buttonText: 'Tool List',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Inventory(),
                        ),
                      );
                    }),
                SizedBox(height: 15),
                CommonButton(
                    customWidth: MyUtility(context).width,
                    buttonText: 'Meeting Request',
                    buttonColor: MyColors().lightBlue,
                    textColor: MyColors().black,
                    onTap: () {}),
                SizedBox(height: 15),
                CommonButton(
                    customWidth: MyUtility(context).width,
                    buttonText: 'Notes',
                    buttonColor: MyColors().yellow,
                    textColor: MyColors().black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MentorNotes(),
                        ),
                      );
                    }),
                    SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
