import 'package:farming_gods_way/Animal_Pen/animalFields.dart';
import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Crop_fields/cropFields.dart';
import 'package:farming_gods_way/Farmers_guide/farmersGuide.dart';
import 'package:farming_gods_way/Farmhouse_Forum/forumTopicList.dart';
import 'package:farming_gods_way/Inventory/inventory.dart';
import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Mentor_programme/mentorPage.dart';
import 'package:farming_gods_way/Messages/Messages.dart';
import 'package:farming_gods_way/Tasks/tasksHome.dart';
import 'package:flutter/material.dart';

class MyBurgerMenuPage extends StatefulWidget {
  const MyBurgerMenuPage({super.key});

  @override
  State<MyBurgerMenuPage> createState() => _MyBurgerMenuPageState();
}

class _MyBurgerMenuPageState extends State<MyBurgerMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        color: MyColors().offWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                color: MyColors().forestGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CornerHeaderContainer(
                      header: 'Menu',
                      hasBackArrow: true,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                          buttonColor: MyColors().offWhite,
                          textColor: MyColors().black,
                          customWidth: MyUtility(context).width * 0.50 - 15,
                          buttonText: 'Home',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FgwLandingPage()),
                            );
                          },
                        ),
                        CommonButton(
                            customWidth: MyUtility(context).width * 0.50 - 15,
                            buttonText: 'Tasks',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TasksHome()),
                              );
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                          customWidth: MyUtility(context).width * 0.50 - 15,
                          buttonText: 'Farmers Guide',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FarmersGuide()),
                            );
                          },
                        ),
                        CommonButton(
                            customWidth: MyUtility(context).width * 0.50 - 15,
                            buttonText: 'Inventory',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Inventory()),
                              );
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                          customWidth: MyUtility(context).width * 0.50 - 15,
                          buttonText: 'Crop Fields',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CropFields()),
                            );
                          },
                        ),
                        CommonButton(
                            customWidth: MyUtility(context).width * 0.50 - 15,
                            buttonText: 'Animal Pens',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AnimalFields()),
                              );
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                          customWidth: MyUtility(context).width * 0.50 - 15,
                          buttonText: 'Farmhouse Forum',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForumTopicList()),
                            );
                          },
                        ),
                        CommonButton(
                            customWidth: MyUtility(context).width * 0.50 - 15,
                            buttonText: MyUtility(context).width < 404
                                ? 'Mentor\nProgramme'
                                : 'Mentor Programme',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MentorPage()),
                              );
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MyUtility(context).width - 20,
                      height: 5,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButton(
                      buttonColor: MyColors().yellow,
                      textColor: MyColors().black,
                      customWidth: MyUtility(context).width - 20,
                      buttonText: 'Settings',
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonButton(
                      buttonColor: MyColors().lightBlue,
                      textColor: MyColors().black,
                      customWidth: MyUtility(context).width - 20,
                      buttonText: 'Messages',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Messages(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
