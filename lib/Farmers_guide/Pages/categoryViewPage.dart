import 'package:farming_gods_way/Farmers_guide/Pages/farmItemGuide.dart';
import 'package:farming_gods_way/Farmers_guide/ui/categoryGuideItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class CategoryViewPage extends StatefulWidget {
  const CategoryViewPage({super.key});

  @override
  State<CategoryViewPage> createState() => _CategoryViewPageState();
}

class _CategoryViewPageState extends State<CategoryViewPage> {
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
              header: 'Crops',
              hasBackArrow: true,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: MyUtility(context).width * 0.93,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: MyColors().offWhite,
              ),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: GoogleFonts.robotoSlab(
                        color: const Color.fromARGB(255, 196, 196, 196),
                        fontSize: 25),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: MyUtility(context).height - 235,
              width: MyUtility(context).width * 0.93,
              decoration: BoxDecoration(
                color: MyColors().offWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryGuideItem(
                            image: 'images/tomatos.png',
                            name: 'Tomatoes',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FarmItemGuide()),
                              );
                            },
                          ),
                          CategoryGuideItem(
                            image: 'images/potatoes.png',
                            name: 'Potatoes',
                            onTap: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryGuideItem(
                            image: 'images/corn.png',
                            name: 'Corn',
                            onTap: () {},
                          ),
                          CategoryGuideItem(
                            image: 'images/beetroot.png',
                            name: 'Beetroot',
                            onTap: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryGuideItem(
                            image: 'images/spinach2.png',
                            name: 'Spinach',
                            onTap: () {},
                          ),
                          CategoryGuideItem(
                            image: 'images/carrots.png',
                            name: 'Carrot',
                            onTap: () {},
                          ),
                        ],
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
