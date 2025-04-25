import 'package:farming_gods_way/Farmhouse_Forum/pages/forumPostsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class ForumTopicList extends StatefulWidget {
  const ForumTopicList({super.key});

  @override
  State<ForumTopicList> createState() => _ForumTopicListState();
}

class _ForumTopicListState extends State<ForumTopicList> {
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
              hasBackArrow: false,
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                width: MyUtility(context).width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.seedling, 
                          name: 'Crops',
                          isOdd: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForumPostsList()),
                            );
                          },
                        ),
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.cow,
                          name: 'Livestock',
                          isOdd: false,
                          onTap: () {},
                        ),
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.bug,
                          name: 'Pest Control',
                          isOdd: true,
                          onTap: () {},
                        ),
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.tractor,
                          name: 'Tools/Equipment',
                          isOdd: false,
                          onTap: () {},
                        ),
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.mountain,
                          name: 'Soil',
                          isOdd: true,
                          onTap: () {},
                        ),
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.leaf,
                          name: 'Seeds',
                          isOdd: false,
                          onTap: () {},
                        ),
                        _buildForumCategoryItem(
                          icon: FontAwesomeIcons.wheatAlt,
                          name: 'Animal Feed',
                          isOdd: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForumCategoryItem({
    required IconData icon,
    required String name,
    required bool isOdd,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isOdd
                    ? [
                        MyColors().lightGreen.withOpacity(0.9),
                        MyColors().forestGreen.withOpacity(0.7),
                      ]
                    : [
                        MyColors().offWhite,
                        Colors.white,
                      ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isOdd ? Colors.white.withOpacity(0.2) : MyColors().forestGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(
                      icon,
                      size: 24,
                      color: isOdd ? Colors.white : MyColors().forestGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isOdd ? Colors.white : MyColors().black,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isOdd ? Colors.white.withOpacity(0.7) : MyColors().forestGreen,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 100.ms * (isOdd ? 1 : 2)).slideX(
            begin: isOdd ? -0.1 : 0.1,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutQuad,
          ),
    );
  }
}
