import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/pages/farmerSignUpStepFour.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class FarmerSignUpStepThree extends StatefulWidget {
  const FarmerSignUpStepThree({super.key});

  @override
  State<FarmerSignUpStepThree> createState() => _FarmerSignUpStepThreeState();
}

class _FarmerSignUpStepThreeState extends State<FarmerSignUpStepThree> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController country = TextEditingController();
  final TextEditingController province = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController homeAddress = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proceed to the next step
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmerSignUpStepFour(),
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
                              "Location Information",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 3 of 4",
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            
                            // Country field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Country",
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
                                    controller: country,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your country',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                      prefixIcon: Icon(Icons.public, color: MyColors().forestGreen),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Country is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 20),
                            
                            // Province field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Province",
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
                                    controller: province,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your province/state',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                      prefixIcon: Icon(FontAwesomeIcons.mapLocation, color: MyColors().forestGreen),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Province is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 20),
                            
                            // District field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "District",
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
                                    controller: district,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your district',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                      prefixIcon: Icon(FontAwesomeIcons.locationDot, color: MyColors().forestGreen),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'District is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 20),
                            
                            // Home Address field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Home Address",
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
                                    controller: homeAddress,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your complete home address',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 15, top: 15),
                                        child: Icon(Icons.home, color: MyColors().forestGreen),
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Home Address is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 700.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 40),
                            
                            // Next button
                            Center(
                              child: CommonButton(
                                customWidth: 160,
                                buttonText: 'Next',
                                onTap: _submitForm,
                              ),
                            ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
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
