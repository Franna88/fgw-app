import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Crop_fields/pages/Full_Portion_view/fullPortionView.dart';
import 'package:farming_gods_way/Crop_fields/pages/farmPortions/farmPortionsPage.dart';
import 'package:farming_gods_way/Inventory/inventory.dart';
import 'package:farming_gods_way/Production_Records/productionRecords.dart';
import 'package:farming_gods_way/Reminders/userReminders.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/cornerHeaderContainer.dart';

class CropFieldView extends StatefulWidget {
  final Map<String, String> field;
  const CropFieldView({super.key, required this.field});

  @override
  State<CropFieldView> createState() => _CropFieldViewState();
}

class _CropFieldViewState extends State<CropFieldView> {
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
                        header: 'Test Field',
                        hasBackArrow: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: MyUtility(context).height * 0.40,
                        width: MyUtility(context).width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.field['image']!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                          customWidth: MyUtility(context).width,
                          buttonText: 'Portions',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FarmPortionsPage()),
                            );
                          }),
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
