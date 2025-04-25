import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myDropDownButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/mySearchBarWidget.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Farmhouse_Forum/pages/forumPostView.dart';
import 'package:farming_gods_way/Farmhouse_Forum/pages/newForumPost.dart';
import 'package:farming_gods_way/Farmhouse_Forum/pages/ui/postListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';

class ForumPostsList extends StatefulWidget {
  const ForumPostsList({super.key});

  @override
  State<ForumPostsList> createState() => _ForumPostsListState();
}

class _ForumPostsListState extends State<ForumPostsList> {
  final searchController = TextEditingController();
  String selectedFilter = 'New';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            Column(
              children: [
                FgwTopBar().animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 15),
                CornerHeaderContainer(
                  header: 'Farmhouse Forum',
                  hasBackArrow: true,
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MySearchBarWidget().animate().fadeIn(delay: 200.ms),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Forum Topics',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      MyDropDownButton(
                        items: ['New', 'Oldest'],
                        customWidth: MyUtility(context).width * 0.25,
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value ?? 'New';
                          });
                        },
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    width: MyUtility(context).width * 0.95,
                    decoration: BoxDecoration(
                      color: MyColors().offWhite.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: ListView.builder(
                        itemCount: 5, // Example count
                        padding: const EdgeInsets.only(top: 10, bottom: 80),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          // Example data
                          return PostListItem(
                            date: '2024/05/${23 - index}',
                            topicMessage: 'Example topic about farming practices and techniques for sustainable growth...',
                            userName: 'User ${index + 1}',
                            userImage: 'images/userImage.png',
                            time: '${11 - index}:00',
                            repliesTotal: '${20 - index * 2} Replies',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForumPostView(),
                                ),
                              );
                            },
                          ).animate().fadeIn(delay: 100.ms * (index + 1)).slideY(begin: 0.05, end: 0);
                        },
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ),
              ],
            ),

            // Floating Button
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: CommonButton(
                customHeight: 50,
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
              ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
