import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmLoaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:farming_gods_way/services/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farming_gods_way/services/firebase_service.dart';

import '../../../Constants/colors.dart';

class FarmerSignUpStepFour extends StatefulWidget {
  const FarmerSignUpStepFour({super.key});

  @override
  State<FarmerSignUpStepFour> createState() => _FarmerSignUpStepFourState();
}

class _FarmerSignUpStepFourState extends State<FarmerSignUpStepFour> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController farmExp = TextEditingController();
  final TextEditingController numberFarms = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isRegistering = false;
  String? error;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() {
        isRegistering = true;
        error = null;
      });

      try {
        // Collect farming experience data
        Map<String, dynamic> farmingData = {
          'yearsOfExperience': farmExp.text,
          'numberOfFarms': numberFarms.text,
          'registrationCompleted': true,
          'registrationDate': DateTime.now().toIso8601String(),
        };

        // Store the final data
        Provider.of<UserProvider>(context, listen: false)
            .storeRegistrationData(farmingData);

        // Create the user account with all the collected data
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final success = await userProvider
            .createUserWithRegistrationData(passwordController.text);

        if (success) {
          // Registration successful, proceed to farm registration
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FarmLocation(),
            ),
          );
        } else {
          // Registration failed
          setState(() {
            error = userProvider.error ?? 'Registration failed';
            isRegistering = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        setState(() {
          error = e.toString();
          isRegistering = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
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
                              "Farming Experience",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 4 of 4",
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
                    padding: const EdgeInsets.all(25),
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
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),

                                  // Farming Experience field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Farming Experience (years)",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: farmExp,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter years of farming experience',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Icon(
                                                FontAwesomeIcons.seedling,
                                                color: MyColors().forestGreen),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Farming experience is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms)
                                      .slideY(begin: 0.1, end: 0),

                                  const SizedBox(height: 30),

                                  // Number of Farms field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Number of Farms",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: numberFarms,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter number of farms you manage',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Icon(
                                                FontAwesomeIcons.tractor,
                                                color: MyColors().forestGreen),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Number of farms is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 100.ms)
                                      .slideY(begin: 0.1, end: 0),

                                  const SizedBox(height: 20),

                                  // Password fields
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Password",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter your password',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Icon(Icons.lock_outline,
                                                color: MyColors().forestGreen),
                                          ),
                                          validator: _validatePassword,
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 600.ms, delay: 200.ms)
                                      .slideY(begin: 0.1, end: 0),

                                  const SizedBox(height: 20),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Confirm Password",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: confirmPasswordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Confirm your password',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Icon(Icons.lock_outline,
                                                color: MyColors().forestGreen),
                                          ),
                                          validator: _validateConfirmPassword,
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 700.ms, delay: 300.ms)
                                      .slideY(begin: 0.1, end: 0),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Complete Registration button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              isRegistering
                                  ? const CircularProgressIndicator()
                                  : CommonButton(
                                      customWidth: 240,
                                      buttonText: 'Complete Registration',
                                      onTap: _submitForm,
                                    ),
                              const SizedBox(height: 15),
                              if (error != null)
                                Text(
                                  error!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              else
                                Text(
                                  "You're almost there!",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
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
