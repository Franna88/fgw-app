import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class NewForumPost extends StatefulWidget {
  const NewForumPost({super.key});

  @override
  State<NewForumPost> createState() => _NewForumPostState();
}

class _NewForumPostState extends State<NewForumPost> {
  final postHeadline = TextEditingController();
  final post = TextEditingController();
  bool isAttachingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MyUtility(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MyColors().forestGreen, MyColors().lightGreen],
                stops: const [0.2, 0.9],
              ),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(60)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  CornerHeaderContainer(
                    header: 'New Post', 
                    hasBackArrow: true
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
                  const SizedBox(height: 25),

                  // Post Input Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Your Post",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: MyColors().forestGreen,
                            ),
                          ),
                          const SizedBox(height: 15),
                          LabeledTextField(
                            label: 'Post Headline',
                            hintText: 'Enter a descriptive title',
                            controller: postHeadline,
                          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                          const SizedBox(height: 15),
                          LabeledTextField(
                            label: 'Post Content',
                            hintText: 'Share your farming knowledge or question...',
                            controller: post, 
                            lines: 8,
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 25),
                  
                  // Attachment Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Attach Image",
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors().forestGreen,
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.paperclip,
                                size: 18,
                                color: MyColors().forestGreen,
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAttachingImage = !isAttachingImage;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Image picker will be implemented here'),
                                  backgroundColor: MyColors().forestGreen,
                                ),
                              );
                            },
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColors().offWhite,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isAttachingImage 
                                      ? MyColors().forestGreen 
                                      : Colors.grey.shade300,
                                  width: isAttachingImage ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: isAttachingImage
                                    ? Icon(
                                        Icons.check_circle,
                                        size: 50,
                                        color: MyColors().forestGreen,
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_outlined,
                                            size: 50,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Tap to attach an image",
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey.shade600,
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
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 30),
                  
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.5,
                    customHeight: 50,
                    buttonText: 'Post',
                    buttonColor: MyColors().yellow,
                    textColor: MyColors().black,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
