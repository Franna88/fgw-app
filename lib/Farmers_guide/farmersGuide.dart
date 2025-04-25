import 'package:farming_gods_way/Farmers_guide/Pages/categoryViewPage.dart';
import 'package:farming_gods_way/Farmers_guide/ui/farmersGuideCategoryItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
          ),
          child: Column(
            children: [
              FgwTopBar(),
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: 'Farmers Guide Book',
                hasBackArrow: false,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  width: MyUtility(context).width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Text(
                          'Categories',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: myColors.forestGreen,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              FarmersGuideCategoryItems(
                                image: 'images/crops.png',
                                name: 'Crops',
                                description: 'Learn about all types of crops and how to grow them',
                                icon: FontAwesomeIcons.seedling,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryViewPage(category: 'Crops')),
                                  );
                                },
                              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                              FarmersGuideCategoryItems(
                                image: 'images/livestock.png',
                                name: 'Livestock',
                                description: 'Best practices for raising healthy animals',
                                icon: FontAwesomeIcons.cow,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryViewPage(category: 'Livestock')),
                                  );
                                },
                              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                              FarmersGuideCategoryItems(
                                image: 'images/pestControl.png',
                                name: 'Pest Control',
                                description: 'Natural and effective pest management',
                                icon: FontAwesomeIcons.bug,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryViewPage(category: 'Pest Control')),
                                  );
                                },
                              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                              FarmersGuideCategoryItems(
                                image: 'images/soil.png',
                                name: 'Soil Management',
                                description: 'Techniques for healthy and productive soil',
                                icon: FontAwesomeIcons.wheatAwn,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryViewPage(category: 'Soil Management')),
                                  );
                                },
                              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
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
      ),
    );
  }
}
