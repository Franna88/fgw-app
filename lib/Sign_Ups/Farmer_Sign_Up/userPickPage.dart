import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/pages/farmerSignUpStepOne.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:farming_gods_way/Sign_Ups/Worker_Registration/workerSignUpStepOne.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:farming_gods_way/services/user_provider.dart';

class UserPickPage extends StatelessWidget {
  const UserPickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen.withOpacity(0.9),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'images/loginImg.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ).animate().fadeIn(duration: 300.ms),
                      const SizedBox(height: 20),
                      Text(
                        "Join Our Community",
                        style: GoogleFonts.robotoSlab(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 10),
                      Text(
                        "Select your account type to get started",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Main content area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Farmer option
                        _buildOptionCard(
                          context: context,
                          title: 'Farmer',
                          description:
                              'Register as a farmer to manage your farm and connect with resources',
                          icon: FontAwesomeIcons.tractor,
                          color: MyColors().forestGreen,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FarmerSignUpStepOne(),
                              ),
                            );
                          },
                        )
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 20),

                        // Worker option
                        _buildOptionCard(
                          context: context,
                          title: 'Worker',
                          description:
                              'Register as a farm worker to find job opportunities',
                          icon: FontAwesomeIcons.personDigging,
                          color: MyColors().forestGreen,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const WorkerSignUpStepOne(),
                              ),
                            );
                          },
                        )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 200.ms)
                            .slideY(begin: 0.1, end: 0),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.05, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        // Clear any existing registration data before starting new flow
        Provider.of<UserProvider>(context, listen: false)
            .clearRegistrationData();

        // Set the user type in the registration data
        Provider.of<UserProvider>(context, listen: false)
            .storeRegistrationData({'userType': title.toLowerCase()});

        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
