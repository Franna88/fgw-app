import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myDropDownButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/mySearchBarWidget.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Farmhouse_Forum/pages/forumPostView.dart';
import 'package:farming_gods_way/Farmhouse_Forum/pages/newForumPost.dart';
import 'package:farming_gods_way/Farmhouse_Forum/pages/ui/postListItem.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';

class ForumPostsList extends StatefulWidget {
  const ForumPostsList({super.key});

  @override
  State<ForumPostsList> createState() => _ForumPostsListState();
}

class _ForumPostsListState extends State<ForumPostsList> {
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
                    MySearchBarWidget(),
                    SizedBox(height: 15),
                    MyDropDownButton(
                      items: ['New', 'Oldest'],
                      customWidth: MyUtility(context).width * 0.25,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MyUtility(context).height - 290,
                      width: MyUtility(context).width * 0.93,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: PostListItem(
                        date: '2024/05/23',
                        topicMessage:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ',
                        userName: 'Eric Bester',
                        userImage: 'images/userImage.png',
                        time: '11:00',
                        repliesTotal: '23 Replies',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForumPostView(),),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Button
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: CommonButton(
                customHeight: 40,
                textColor: MyColors().black,
                buttonColor: MyColors().yellow,
                customWidth: MyUtility(context).width,
                buttonText: 'Create New Post',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewForumPost()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
