import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/pages/farmerSignUpStepThree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:farming_gods_way/services/user_provider.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class FarmerSignUpStepTwo extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const FarmerSignUpStepTwo({super.key, this.userData});

  @override
  State<FarmerSignUpStepTwo> createState() => _FarmerSignUpStepTwoState();
}

class _FarmerSignUpStepTwoState extends State<FarmerSignUpStepTwo> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController birthDate = TextEditingController();
  final TextEditingController homeLanguage = TextEditingController();
  final TextEditingController proficiencyEnglish = TextEditingController();

  String? selectedGender;
  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];
  final List<String> proficiencyOptions = [
    'Basic',
    'Intermediate',
    'Advanced',
    'Fluent'
  ];
  String? selectedProficiency;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect data from this step
      Map<String, dynamic> stepTwoData = {
        'dateOfBirth': birthDate.text,
        'gender': selectedGender,
        'homeLanguage': homeLanguage.text,
        'englishProficiency': selectedProficiency,
      };

      // Store data using provider
      Provider.of<UserProvider>(context, listen: false)
          .storeRegistrationData(stepTwoData);

      // Proceed to the next step
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmerSignUpStepThree(),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors().forestGreen,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        birthDate.text = "${picked.day}/${picked.month}/${picked.year}";
      });
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
                              "Personal Information",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 2 of 4",
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
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
                        flex: 2,
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

                            // Date of Birth field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date of Birth",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      controller: birthDate,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Select your date of birth',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 16),
                                        prefixIcon: Icon(Icons.calendar_today,
                                            color: MyColors().forestGreen),
                                        suffixIcon: Icon(Icons.arrow_drop_down,
                                            color: Colors.grey[600]),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Date of Birth is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 20),

                            // Gender dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender",
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedGender,
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.grey[600]),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Select your gender',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                      prefixIcon: Icon(Icons.person,
                                          color: MyColors().forestGreen),
                                    ),
                                    items: genderOptions.map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGender = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your gender';
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

                            // Home Language field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Home Language",
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: TextFormField(
                                    controller: homeLanguage,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your home language',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 16),
                                      prefixIcon: Icon(Icons.language,
                                          color: MyColors().forestGreen),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Home Language is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 200.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 20),

                            // English Proficiency dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "English Proficiency",
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedProficiency,
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.grey[600]),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Select your proficiency level',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                      prefixIcon: Icon(Icons.translate,
                                          color: MyColors().forestGreen),
                                    ),
                                    items: proficiencyOptions
                                        .map((String proficiency) {
                                      return DropdownMenuItem<String>(
                                        value: proficiency,
                                        child: Text(proficiency),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedProficiency = newValue;
                                        proficiencyEnglish.text =
                                            newValue ?? '';
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your proficiency level';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            )
                                .animate()
                                .fadeIn(duration: 700.ms, delay: 300.ms)
                                .slideY(begin: 0.1, end: 0),

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
