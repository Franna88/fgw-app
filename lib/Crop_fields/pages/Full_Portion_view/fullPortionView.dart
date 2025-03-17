import 'package:farming_gods_way/Crop_fields/pages/Full_Portion_view/ui/portionRowTaskItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';
import '../Create_Portion/ui/portionInfo.dart';

class FullPortionView extends StatefulWidget {
  const FullPortionView({super.key});

  @override
  State<FullPortionView> createState() => _FullPortionViewState();
}

class _FullPortionViewState extends State<FullPortionView> {
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
                  colors: [
                    MyColors().forestGreen,
                    MyColors().lightGreen,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  CornerHeaderContainer(
                    header: 'Portion A',
                    hasBackArrow: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 120,
                    width: MyUtility(context).width * 0.90,
                    decoration: BoxDecoration(
                      color: MyColors().offWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Selected portion type
                              Text(
                                'Root Type',
                                style: GoogleFonts.roboto(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // selected row type
                              Text(
                                '5 Rows',
                                style: GoogleFonts.roboto(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // selected crop
                              Text(
                                'Carrot',
                                style: GoogleFonts.roboto(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // depends on the portion type selected if Root type was selected : 'images/carrot.png' , if Leaf type was selected : 'images/spinach.png' , if Fruit type was selected : 'images/apple.png'
                          Image.asset('images/carrot.png'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 160,
                    width: MyUtility(context).width * 0.90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors().offWhite),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          PortionInfo(
                              text: 'Estimated harvest amount',
                              amounts: '55 plants'),
                          PortionInfo(text: 'Planting Depth', amounts: '3 cm'),
                          PortionInfo(
                              text: 'Distance in row', amounts: '12 cm'),
                          PortionInfo(
                              text: 'Distance between row', amounts: '12 cm'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MyUtility(context).height * 0.95 - 405,
                    width: MyUtility(context).width * 0.90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: MyColors().offWhite),
                    child: Column(
                      children: [
                        PortionRowTaskItem(
                            row: 'Row 1',
                            progressValue: 0.5,
                            rowFaze: 'Preparation',
                            onTap: (){})
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
