import 'package:farming_gods_way/Inventory/inventoryItemsPage.dart';
import 'package:farming_gods_way/Inventory/ui/inventoryCategoryItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          height: MyUtility(context).height,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60),
            ),
          ),
          child: Column(
            children: [
              const FgwTopBar(),
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: 'Inventory',
                hasBackArrow: false,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildCategoryHeader(myColors),
                          InventoryCategoryItem(
                            styleOne: true,
                            image: 'images/cropIcon.png',
                            name: 'Crops',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Crops',
                                  )),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 100)),
                          
                          InventoryCategoryItem(
                            styleOne: false,
                            image: 'images/livestockIcon.png',
                            name: 'Livestock',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Livestock',
                                  ),
                                ),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 150)),
                          
                          InventoryCategoryItem(
                            styleOne: true,
                            image: 'images/pestControlIcon.png',
                            name: 'Pest Control',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Pest Control',
                                  ),
                                ),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 200)),
                          
                          InventoryCategoryItem(
                            styleOne: false,
                            image: 'images/toolsIcon.png',
                            name: 'Tools/Equipment',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Tools/Equipment',
                                  ),
                                ),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 250)),
                          
                          InventoryCategoryItem(
                            styleOne: true,
                            image: 'images/soilIcon.png',
                            name: 'Soil',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Soil',
                                  ),
                                ),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 300)),
                          
                          InventoryCategoryItem(
                            styleOne: false,
                            image: 'images/seedsIcon.png',
                            name: 'Seeds',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Seeds',
                                  ),
                                ),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 350)),
                          
                          InventoryCategoryItem(
                            styleOne: true,
                            image: 'images/feedIcon.png',
                            name: 'Animal Feed',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InventoryItemsPage(
                                    category: 'Animal Feed',
                                  ),
                                ),
                              );
                            },
                          ).animate().fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 400)),
                          
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoryHeader(MyColors myColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: myColors.forestGreen.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: myColors.forestGreen.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.category_outlined,
            color: myColors.forestGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Categories',
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: myColors.forestGreen,
            ),
          ),
        ],
      ),
    );
  }
}
