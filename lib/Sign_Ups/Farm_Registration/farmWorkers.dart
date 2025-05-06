import 'package:farming_gods_way/CommonUi/Buttons/counterWidget.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Login/login.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:farming_gods_way/services/user_provider.dart';
import 'package:farming_gods_way/services/firebase_service.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../Constants/colors.dart';

class FarmWorkers extends StatefulWidget {
  const FarmWorkers({super.key});

  @override
  State<FarmWorkers> createState() => _FarmWorkersState();
}

class _FarmWorkersState extends State<FarmWorkers> {
  int _workerCount = 0;
  String? _selectedExperience;
  bool isLoading = false;

  final _experienceLevels = [
    'No Experience',
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    'More than 10 years'
  ];

  void _completeRegistration() async {
    if (_selectedExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select worker experience level'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Get the farmId from provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final farmId = userProvider.registrationData['farmId'];

      if (farmId != null) {
        // Save workers data
        final workersData = {
          'workerCount': _workerCount,
          'workerExperience': _selectedExperience,
          'registrationStep': 'workers',
          'registrationComplete': true,
          'registrationCompletedAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Store in provider
        userProvider.storeRegistrationData(workersData);

        // Update in Firestore
        await FirebaseService.firestore
            .collection('farms')
            .doc(farmId)
            .update(workersData);

        // Show success dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Registration Complete',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Your farm registration has been successfully completed!',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to login
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Farm ID not found. Please restart farm registration.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving workers data: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ).animate().fadeIn(duration: 300.ms),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Farm Workers",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Final Step",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress indicator
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ),

                const SizedBox(height: 10),

                // Form content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "Workers Information",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 10),

                        // Description
                        Text(
                          "Tell us about the available workers on your farm",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 30),

                        // Number of workers
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Number of Available Workers",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.userGroup,
                                        color: MyColors().forestGreen,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        "Workers",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomCounterWidget(
                                  count: _workerCount,
                                  onChanged: (value) {
                                    setState(() {
                                      _workerCount = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

                        const SizedBox(height: 30),

                        // Average experience dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average Experience of Workers",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedExperience,
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'Select experience level',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(12),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: MyColors().forestGreen,
                                  ),
                                  items: _experienceLevels.map((String level) {
                                    return DropdownMenuItem<String>(
                                      value: level,
                                      child: Text(
                                        level,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedExperience = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

                        const Spacer(),

                        // Completion message
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green[100]!),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green[700],
                                size: 40,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "You've completed all steps!",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[800],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Your farm registration is now ready for submission",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

                        const SizedBox(height: 30),

                        // Complete button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              isLoading
                                  ? CircularProgressIndicator(
                                      color: MyColors().forestGreen,
                                    )
                                  : CommonButton(
                                      customWidth: 240,
                                      buttonText: 'Complete Registration',
                                      onTap: _completeRegistration,
                                    ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms, delay: 500.ms),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.05, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCounterWidget extends StatelessWidget {
  final int count;
  final Function(int) onChanged;

  const CustomCounterWidget({
    Key? key,
    required this.count,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: () {
              if (count > 0) {
                onChanged(count - 1);
              }
            },
            isEnabled: count > 0,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 50),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              count.toString(),
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: () => onChanged(count + 1),
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isEnabled ? MyColors().forestGreen : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
