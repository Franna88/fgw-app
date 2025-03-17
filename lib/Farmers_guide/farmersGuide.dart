import 'package:farming_gods_way/Farmers_guide/Pages/categoryViewPage.dart';
import 'package:farming_gods_way/Farmers_guide/ui/farmersGuideCategoryItems.dart';
import 'package:flutter/material.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class FarmersGuide extends StatefulWidget {
  const FarmersGuide({super.key});

  @override
  State<FarmersGuide> createState() => _FarmersGuideState();
}

class _FarmersGuideState extends State<FarmersGuide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            FgwTopBar(),
            SizedBox(
              height: 15,
            ),
            CornerHeaderContainer(
              header: 'Farmers Guide Book',
              hasBackArrow: false,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: MyUtility(context).height - 160,
              width: MyUtility(context).width * 0.93,
              decoration: BoxDecoration(
                color: MyColors().offWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FarmersGuideCategoryItems(
                      image: 'images/crops.png',
                      name: 'Crops',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CategoryViewPage()),
                        );
                      },
                    ),
                    FarmersGuideCategoryItems(
                      image: 'images/livestock.png',
                      name: 'Livestock',
                      onTap: () {},
                    ),
                    FarmersGuideCategoryItems(
                      image: 'images/pestControl.png',
                      name: 'Pest Control',
                      onTap: () {},
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
