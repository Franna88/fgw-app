import 'package:farming_gods_way/Animal_Pen/animalFields.dart';
import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Crop_fields/cropFields.dart';
import 'package:farming_gods_way/Farmers_guide/farmersGuide.dart';
import 'package:farming_gods_way/Farmhouse_Forum/forumTopicList.dart';
import 'package:farming_gods_way/Inventory/inventory.dart';
import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Mentor_programme/mentorPage.dart';
import 'package:farming_gods_way/Messages/Messages.dart';
import 'package:farming_gods_way/Profile/profileSettings.dart';
import 'package:farming_gods_way/Tasks/tasksHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBurgerMenuPage extends StatefulWidget {
  const MyBurgerMenuPage({super.key});

  @override
  State<MyBurgerMenuPage> createState() => _MyBurgerMenuPageState();
}

class _MyBurgerMenuPageState extends State<MyBurgerMenuPage> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Material(
      child: Container(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        color: Colors.white,
        child: Column(
          children: [
            // Top bar with back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: myColors.forestGreen,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Menu content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // User profile section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: myColors.offWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: myColors.lightGreen,
                          child: const Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Farmer John',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Small Scale Farmer',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: myColors.forestGreen,
                          ),
                          onPressed: () {
                            // Navigate to the ProfileSettings page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileSettings(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Section: Farm Management
                  _buildSectionHeader('Farm Management'),
                  _buildMenuItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FgwLandingPage()),
                      );
                    },
                    color: myColors.forestGreen,
                    delay: 1,
                  ),
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileSettings()),
                      );
                    },
                    color: myColors.forestGreen,
                    delay: 2,
                  ),
                  _buildMenuItem(
                    icon: Icons.task_alt,
                    title: 'Tasks',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TasksHome()),
                      );
                    },
                    color: myColors.lightGreen,
                    delay: 3,
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.leaf,
                    title: 'Crop Fields',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CropFields()),
                      );
                    },
                    color: myColors.green,
                    delay: 4,
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.cow,
                    title: 'Animal Pens',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AnimalFields()),
                      );
                    },
                    color: myColors.yellow,
                    delay: 5,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section: Resources & Learning
                  _buildSectionHeader('Resources & Learning'),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.book,
                    title: 'Farmers Guide',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FarmersGuide()),
                      );
                    },
                    color: myColors.lightBlue,
                    delay: 6,
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.peopleGroup,
                    title: 'Mentor Programme',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MentorPage()),
                      );
                    },
                    color: myColors.lightGreen,
                    delay: 7,
                  ),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.comments,
                    title: 'Farmhouse Forum',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForumTopicList()),
                      );
                    },
                    color: myColors.forestGreen,
                    delay: 8,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section: Tools & Utilities
                  _buildSectionHeader('Tools & Utilities'),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.boxesStacked,
                    title: 'Inventory',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Inventory()),
                      );
                    },
                    color: myColors.yellow,
                    delay: 9,
                  ),
                  _buildMenuItem(
                    icon: Icons.message,
                    title: 'Messages',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Messages()),
                      );
                    },
                    color: myColors.lightBlue,
                    delay: 10,
                    showBadge: true,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Logout button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Logout functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout functionality not implemented yet')),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
    required int delay,
    bool showBadge = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MyColors().red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms * delay.toDouble())
      .slideX(begin: -0.1, end: 0, duration: 300.ms, curve: Curves.easeOutQuad);
  }
}
