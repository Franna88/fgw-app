import 'package:farming_gods_way/Farmhouse_Forum/pages/ui/fullForumPostItem.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class ForumPostView extends StatefulWidget {
  const ForumPostView({super.key});

  @override
  State<ForumPostView> createState() => _ForumPostViewState();
}

class _ForumPostViewState extends State<ForumPostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding:
                  EdgeInsets.only(bottom: 80), // Prevent overlap with button
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FgwTopBar(),
                    SizedBox(height: 15),
                    CornerHeaderContainer(
                      header: 'Farmhouse Forum',
                      hasBackArrow: false,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MyUtility(context).height - 180,
                      width: MyUtility(context).width * 0.93,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: FullForumPostItem(
                        date: '2024/05/23',
                        topicMessage:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ',
                        userName: 'Eric Bester',
                        userImage: 'images/userImage.png',
                        time: '11:00',
                        repliesTotal: '23 Replies',
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 00,
              child: Container(
                // height: 200,
                width: MyUtility(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        //height: 50,
                        width: MyUtility(context).width - 120,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 216, 216),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: ShapeDecoration(
                          color: MyColors().forestGreen,
                          shape: CircleBorder(),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
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
