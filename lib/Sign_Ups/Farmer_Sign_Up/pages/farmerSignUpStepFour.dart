import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmLoaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proceed to the next step
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmLocation(),
        ),
      );
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: farmExp,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter years of farming experience',
                                            hintStyle: TextStyle(color: Colors.grey[400]),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                            prefixIcon: Icon(FontAwesomeIcons.seedling, color: MyColors().forestGreen),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Farming experience is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                                  
                                  const SizedBox(height: 30),
                                  
                                  // Number of Farms field
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: numberFarms,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter number of farms you manage',
                                            hintStyle: TextStyle(color: Colors.grey[400]),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                            prefixIcon: Icon(FontAwesomeIcons.tractor, color: MyColors().forestGreen),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Number of farms is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                                  
                                  const SizedBox(height: 20),
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
                              CommonButton(
                                customWidth: 240,
                                buttonText: 'Complete Registration',
                                onTap: _submitForm,
                              ),
                              const SizedBox(height: 15),
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
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
