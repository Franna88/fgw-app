import 'package:farming_gods_way/Inventory/ui/inventoryItems.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class InventoryItemsPage extends StatefulWidget {
  const InventoryItemsPage({super.key});

  @override
  State<InventoryItemsPage> createState() => _InventoryItemsPageState();
}

class _InventoryItemsPageState extends State<InventoryItemsPage> {
  Map<String, int> _itemCounts = {
    'Potatoes': 0,
    'Beetroot': 0,
    'Tomatos': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            FgwTopBar(),
            SizedBox(height: 15),
            CornerHeaderContainer(
              header: 'Crops',
              hasBackArrow: true,
            ),
            SizedBox(height: 15),
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
                    prefixIcon: Icon(Icons.search, size: 30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: MyUtility(context).height - 235,
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
                    InventoryItems(
                      image: 'images/potatoes.png',
                      name: 'Potatoes',
                      count: _itemCounts['Potatoes'] ?? 0,
                      onChanged: (newCount) {
                        setState(() {
                          _itemCounts['Potatoes'] = newCount;
                        });
                      },
                    ),
                    InventoryItems(
                      image: 'images/beetroot.png',
                      name: 'Beetroot',
                      count: _itemCounts['Beetroot'] ?? 0,
                      onChanged: (newCount) {
                        setState(() {
                          _itemCounts['Beetroot'] = newCount;
                        });
                      },
                    ),
                    InventoryItems(
                      image: 'images/tomatos.png',
                      name: 'Tomatos',
                      count: _itemCounts['Tomatos'] ?? 0,
                      onChanged: (newCount) {
                        setState(() {
                          _itemCounts['Tomatos'] = newCount;
                        });
                      },
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
