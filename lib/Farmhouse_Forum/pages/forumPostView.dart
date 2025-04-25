import 'package:farming_gods_way/Farmhouse_Forum/pages/ui/fullForumPostItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final commentController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            FgwTopBar().animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 15),
            CornerHeaderContainer(
              header: 'Farmhouse Forum',
              hasBackArrow: true,
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
            const SizedBox(height: 15),
            
            // Main content area
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        // Main Post
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: FullForumPostItem(
                            date: '2024/05/23',
                            topicMessage:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation. This is a longer post to demonstrate how the text wraps in the full view mode with a reasonable amount of content that a user might type.',
                            userName: 'Eric Bester',
                            userImage: 'images/userImage.png',
                            time: '11:00',
                            repliesTotal: '23 Replies',
                          ),
                        ).animate().fadeIn(delay: 100.ms),

                        // Replies Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.comments,
                                    size: 18,
                                    color: MyColors().forestGreen,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Replies',
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors().forestGreen,
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(delay: 200.ms),
                              const SizedBox(height: 10),
                              
                              // Reply Cards List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 3, // Example replies
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage('images/userImage.png'),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'User ${index + 1}',
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${11 - index}:${index * 10}',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'This is reply #${index + 1}. A helpful response to the original post with some farming advice or questions about the technique mentioned.',
                                            style: GoogleFonts.roboto(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 300.ms + (100.ms * index)).slideY(begin: 0.05, end: 0);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
            
            // Comment Input Bar
            Container(
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Add your reply...',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (commentController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Reply submitted'),
                              backgroundColor: MyColors().forestGreen,
                            ),
                          );
                          commentController.clear();
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: MyColors().forestGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
