import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../Constants/colors.dart';
import '../../Constants/spaces.dart';
import '../../CommonUi/Buttons/commonButton.dart';
import 'workerFarmerSearch.dart';

class WorkerSignUpStepTwo extends StatefulWidget {
  const WorkerSignUpStepTwo({super.key});

  @override
  State<WorkerSignUpStepTwo> createState() => _WorkerSignUpStepTwoState();
}

class _WorkerSignUpStepTwoState extends State<WorkerSignUpStepTwo> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedGender;
  String? selectedLanguage;
  String? selectedProficiency;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> languages = [
    'English',
    'Afrikaans',
    'Zulu',
    'Xhosa',
    'Sotho',
    'Tswana',
    'Venda',
    'Tsonga',
    'Swati',
    'Ndebele',
    'Other'
  ];
  final List<String> proficiencyLevels = [
    'None',
    'Basic',
    'Intermediate',
    'Advanced',
    'Fluent'
  ];

  String? _validateDateOfBirth(DateTime? date) {
    if (date == null) {
      return 'Date of Birth is required';
    }
    final now = DateTime.now();
    final age = now.year - date.year - 
        (now.month > date.month || (now.month == date.month && now.day >= date.day) ? 0 : 1);
        
    if (age < 18) {
      return 'You must be at least 18 years old';
    }
    return null;
  }

  String? _validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    // Set default date to 18 years ago
    final DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors().forestGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyColors().forestGreen,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _onNextPressed() {
    final dateValidationResult = _validateDateOfBirth(selectedDate);
    
    if (_formKey.currentState!.validate() && dateValidationResult == null) {
      // Proceed to next step if validation is successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WorkerFarmerSearch(),
        ),
      );
    } else {
      if (dateValidationResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dateValidationResult),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.redAccent,
          ),
        );
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
                              "Worker Details",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 2 of 2",
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
                        flex: 1,
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
                            color: Colors.white,
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
                                  'Date of Birth',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: MyColors().forestGreen,
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Text(
                                            selectedDate != null
                                                ? DateFormat('dd MMM yyyy').format(selectedDate!)
                                                : 'Select your date of birth',
                                            style: TextStyle(
                                              color: selectedDate != null
                                                  ? Colors.black87
                                                  : Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 20),
                            
                            // Gender field
                            _buildDropdown(
                              label: 'Gender',
                              hint: 'Select your gender',
                              value: selectedGender,
                              items: genders,
                              icon: Icons.person_outline,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                              validator: (value) => _validateDropdown(value, 'Gender'),
                            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 20),
                            
                            // Home Language field
                            _buildDropdown(
                              label: 'Home Language',
                              hint: 'Select your home language',
                              value: selectedLanguage,
                              items: languages,
                              icon: Icons.language_outlined,
                              onChanged: (value) {
                                setState(() {
                                  selectedLanguage = value;
                                });
                              },
                              validator: (value) => _validateDropdown(value, 'Home Language'),
                            ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 20),
                            
                            // English Proficiency field
                            _buildDropdown(
                              label: 'Proficiency in English',
                              hint: 'Select your level of proficiency',
                              value: selectedProficiency,
                              items: proficiencyLevels,
                              icon: FontAwesomeIcons.language,
                              onChanged: (value) {
                                setState(() {
                                  selectedProficiency = value;
                                });
                              },
                              validator: (value) => _validateDropdown(value, 'Proficiency in English'),
                            ).animate().fadeIn(duration: 700.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                            
                            const SizedBox(height: 40),
                            
                            // Next button
                            Center(
                              child: CommonButton(
                                customWidth: 160,
                                buttonText: 'Next',
                                onTap: _onNextPressed,
                              ),
                            ).animate().fadeIn(duration: 900.ms, delay: 500.ms),
                            
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
  
  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
    required FormFieldValidator<String?> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              prefixIcon: Icon(icon, color: MyColors().forestGreen),
            ),
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey[400]),
            ),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            dropdownColor: Colors.white,
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
