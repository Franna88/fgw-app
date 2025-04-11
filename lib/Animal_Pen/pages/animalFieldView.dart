import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/animalProfile.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/animalProfilesList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';
import '../../Inventory/inventory.dart';
import '../../Production_Records/productionRecords.dart';
import '../../Reminders/userReminders.dart';
import '../../Tasks/tasksHome.dart';

class AnimalFieldView extends StatefulWidget {
  final Map<String, String> field;
  const AnimalFieldView({super.key, required this.field});

  @override
  State<AnimalFieldView> createState() => _AnimalFieldViewState();
}

class _AnimalFieldViewState extends State<AnimalFieldView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(
              height: MyUtility(context).height * 0.05,
            ),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [MyColors().forestGreen, MyColors().lightGreen]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CornerHeaderContainer(
                        //Field name here
                        header: 'Test Field',
                        hasBackArrow: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 200,
                        width: MyUtility(context).width,
                        decoration: BoxDecoration(
                            color: MyColors().offWhite,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 180,
                                width: MyUtility(context).width * 0.40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    //field image here
                                    image: AssetImage('images/livestock.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 50,
                                    width: MyUtility(context).width * 0.40,
                                    decoration: BoxDecoration(
                                      color: MyColors().black,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Sheep',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Field A',
                                    style: GoogleFonts.robotoSlab(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '3 Male',
                                    style: GoogleFonts.robotoSlab(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '3 Female',
                                    style: GoogleFonts.robotoSlab(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 2,
                                    color: MyColors().black,
                                    width: MyUtility(context).width * 0.30,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '6 Total',
                                    style: GoogleFonts.robotoSlab(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                          customWidth: MyUtility(context).width,
                          buttonText: 'Animal Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AnimalProfilesList()),
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                        customWidth: MyUtility(context).width,
                        buttonText: 'Tasks',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TasksHome()),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                        customWidth: MyUtility(context).width,
                        buttonText: 'Reminders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserReminders(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                        customWidth: MyUtility(context).width,
                        buttonText: 'Production Records',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductionRecords(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                        customWidth: MyUtility(context).width,
                        buttonText: 'Inventory',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Inventory()),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CommonButton(
                        buttonColor: MyColors().yellow,
                        textColor: MyColors().black,
                        customWidth: MyUtility(context).width,
                        buttonText: 'Field Settings',
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
