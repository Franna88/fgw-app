import 'package:farming_gods_way/Animal_Pen/pages/New_Animal/newAnimal.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/animalProfile.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/ui/animalProfileItem.dart';
import 'package:flutter/material.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AnimalProfilesList extends StatefulWidget {
  const AnimalProfilesList({super.key});

  @override
  State<AnimalProfilesList> createState() => _AnimalProfilesListState();
}

class _AnimalProfilesListState extends State<AnimalProfilesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColors().forestGreen, MyColors().lightGreen],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CornerHeaderContainer(
                        header: 'Animal Profiles', hasBackArrow: true),
                    const SizedBox(height: 15),
                    CommonButton(
                        buttonColor: MyColors().yellow,
                        textColor: MyColors().black,
                        customWidth: MyUtility(context).width * 0.93,
                        buttonText: 'Add New Animal',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewAnimal()),
                          );
                        }),
                    const SizedBox(height: 15),
                    Container(
                      height: MyUtility(context).height - 196,
                      width: MyUtility(context).width * 0.93,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      //List of Animals
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimalProfileItem(
                              animalImage: 'images/livestock.png',
                              animalName: 'John',
                              animalGender: 'male',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AnimalProfile()),
                                );
                              },
                            ),
                            AnimalProfileItem(
                              animalImage: 'images/livestock.png',
                              animalName: 'Sammy',
                              animalGender: 'female',
                              onTap: () {},
                            )
                          ],
                        ),
                      ),
                    ),
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
