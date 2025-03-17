import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myBackArrowButton.dart';
import 'package:flutter/material.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class SignUpStructure extends StatelessWidget {
  final String header;
  final double? customHight;
  final List<Widget> children;
  final bool isScrollable;

  const SignUpStructure({
    super.key,
    required this.children,
    required this.header,
    this.customHight,
    this.isScrollable = true, // Default to scrollable
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: MyBackArrowButton(),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 80,
                  width: 80,
                  color: MyColors().black,
                  child: const Center(
                    child: Text(
                      'logo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: customHight ?? MyUtility(context).height * 0.75,
                width: MyUtility(context).width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [MyColors().forestGreen, MyColors().lightGreen],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    CornerHeaderContainer(header: header, hasBackArrow: false,),
                    Expanded(
                      child: isScrollable
                          ? SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: children,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: children,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
