import 'package:farming_gods_way/Farmhouse_Forum/pages/forumPostsList.dart';
import 'package:farming_gods_way/Inventory/inventoryItemsPage.dart';
import 'package:farming_gods_way/Inventory/ui/inventoryCategoryItem.dart';
import 'package:flutter/material.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class ForumTopicList extends StatefulWidget {
  const ForumTopicList({super.key});

  @override
  State<ForumTopicList> createState() => _ForumTopicListState();
}

class _ForumTopicListState extends State<ForumTopicList> {
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
              header: 'Farmhouse Forum',
              hasBackArrow: false,
            ),
            SizedBox(
              height: 15, 
            ),
            Container(
              height: MyUtility(context).height - 160,
              width: MyUtility(context).width * 0.93,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InventoryCategoryItem(
                      styleOne: true,
                      image: 'images/cropIcon.png',
                      name: 'Crops',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForumPostsList()),
                        );
                      },
                    ),
                    InventoryCategoryItem(
                      styleOne: false,
                      image: 'images/livestockIcon.png',
                      name: 'Livestock',
                      onTap: () {},
                    ),
                    InventoryCategoryItem(
                      styleOne: true,
                      image: 'images/pestControlIcon.png',
                      name: 'Pest Control',
                      onTap: () {},
                    ),
                    InventoryCategoryItem(
                      styleOne: false,
                      image: 'images/toolsIcon.png',
                      name: 'Tools/Equipment',
                      onTap: () {},
                    ),
                    InventoryCategoryItem(
                      styleOne: true,
                      image: 'images/soilIcon.png',
                      name: 'Soil',
                      onTap: () {},
                    ),
                    InventoryCategoryItem(
                      styleOne: false,
                      image: 'images/seedsIcon.png',
                      name: 'Seeds',
                      onTap: () {},
                    ),
                    InventoryCategoryItem(
                      styleOne: true,
                      image: 'images/feedIcon.png',
                      name: 'Animal Feed',
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
