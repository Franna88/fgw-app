import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class FarmItemGuide extends StatefulWidget {
  const FarmItemGuide({super.key});

  @override
  State<FarmItemGuide> createState() => _FarmItemGuideState();
}

class _FarmItemGuideState extends State<FarmItemGuide> {
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
              header: 'Tomatoes',
              hasBackArrow: true,
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
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        height: MyUtility(context).height * 0.30,
                        width: MyUtility(context).width - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage('images/tomatos.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 40,
                            width: MyUtility(context).width - 40,
                            decoration: BoxDecoration(
                              color: MyColors().black,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tomatos',
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    letterSpacing: 1.1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MyUtility(context).width - 40,
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                          ),
                        ),
                      )
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
