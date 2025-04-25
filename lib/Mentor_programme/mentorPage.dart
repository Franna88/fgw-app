import 'package:farming_gods_way/Animal_Pen/animalFields.dart';
import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Inventory/inventory.dart';
import 'package:farming_gods_way/Mentor_programme/pages/mentorNotes.dart';
import 'package:farming_gods_way/Mentor_programme/ui/farmerDataBlock.dart';
import 'package:farming_gods_way/Mentor_programme/ui/userBlock.dart';
import 'package:farming_gods_way/Tasks/tasksHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Crop_fields/cropFields.dart';

class MentorPage extends StatefulWidget {
  const MentorPage({super.key});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
          ),
          child: Column(
            children: [
              FgwTopBar(),
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: 'Mentor Programme',
                hasBackArrow: false,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserBlock(
                        userImage: 'images/userImage.png', 
                        userName: 'Eric Bester'
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: 15),
                      
                      FarmerDataBlock(
                        age: '45',
                        country: 'country',
                        yearsExp: '3',
                        province: 'province',
                        fgwExp: '2',
                        city: 'city',
                        englishProf: '3'
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Farm Location',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                      
                      const SizedBox(height: 10),
                      
                      Container(
                        width: double.infinity,
                        height: MyUtility(context).height * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Image.asset(
                                'images/mapsPlaceholder.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: myColors.forestGreen.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Farm Location',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: 15),
                      
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Farm Information',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: myColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      context,
                                      'Crop Farm',
                                      FontAwesomeIcons.seedling,
                                      myColors.forestGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildInfoCard(
                                      context,
                                      'Irrigation: Hose',
                                      FontAwesomeIcons.droplet,
                                      myColors.forestGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Farm Management',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                      
                      const SizedBox(height: 15),
                      
                      // Grid of buttons
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.2,
                        children: [
                          _buildActionCard(
                            context,
                            'Task Board',
                            FontAwesomeIcons.clipboardList,
                            myColors.forestGreen,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TasksHome(),
                                ),
                              );
                            },
                            delay: 700.ms,
                          ),
                          _buildActionCard(
                            context,
                            'Crop Fields',
                            FontAwesomeIcons.wheatAwn,
                            myColors.forestGreen,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CropFields(),
                                ),
                              );
                            },
                            delay: 750.ms,
                          ),
                          _buildActionCard(
                            context,
                            'Animal Fields',
                            FontAwesomeIcons.cow,
                            myColors.forestGreen,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AnimalFields(),
                                ),
                              );
                            },
                            delay: 800.ms,
                          ),
                          _buildActionCard(
                            context,
                            'Tool List',
                            FontAwesomeIcons.toolbox,
                            myColors.forestGreen,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Inventory(),
                                ),
                              );
                            },
                            delay: 850.ms,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: CommonButton(
                              customHeight: 50,
                              customWidth: MyUtility(context).width * 0.43,
                              buttonText: 'Meeting Request',
                              buttonColor: myColors.lightBlue,
                              textColor: myColors.black,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CommonButton(
                              customHeight: 50,
                              customWidth: MyUtility(context).width * 0.43,
                              buttonText: 'Notes',
                              buttonColor: myColors.yellow,
                              textColor: myColors.black,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MentorNotes(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(BuildContext context, String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    required Duration delay,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoSlab(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1, end: 0);
  }
}
