import 'package:farming_gods_way/Animal_Pen/pages/New_Animal/animalHealt.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class NewAnimal extends StatefulWidget {
  const NewAnimal({super.key});

  @override
  State<NewAnimal> createState() => _NewAnimalState();
}

class _NewAnimalState extends State<NewAnimal> {
  final animalNameController = TextEditingController();
  final animalAgeController = TextEditingController();
  String? selectedGender;
  bool _isUploading = false;
  
  @override
  void dispose() {
    animalNameController.dispose();
    animalAgeController.dispose();
    super.dispose();
  }
  
  void _pickImage() {
    setState(() {
      _isUploading = true;
    });
    
    // Simulate image upload delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image upload feature coming soon'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
  
  bool get _isFormValid => 
    animalNameController.text.isNotEmpty && 
    animalAgeController.text.isNotEmpty && 
    selectedGender != null;

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          height: MyUtility(context).height,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: 'New Animal',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(myColors, screenWidth),
                      const SizedBox(height: 20),
                      _buildImageUploadSection(myColors, screenWidth),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: CommonButton(
                  customWidth: screenWidth * 0.5,
                  customHeight: 50,
                  buttonText: 'Next',
                  buttonColor: myColors.yellow,
                  textColor: myColors.black,
                  onTap: () {
                    if (_isFormValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnimalHealth(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please fill in all required fields',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: myColors.forestGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(MyColors myColors, double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.paw,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Basic Information',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 16),
            
            LabeledTextField(
              label: 'Animal Name',
              hintText: 'Enter animal name',
              controller: animalNameController,
            ),
            
            const SizedBox(height: 16),
            
            LabeledDropdown(
              label: 'Gender',
              hintText: 'Select gender',
              items: ['Male', 'Female'],
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            LabeledTextField(
              label: 'Animal Age',
              hintText: 'Enter age (e.g., 2 years)',
              controller: animalAgeController,
            ),
            
            if (selectedGender != null || animalNameController.text.isNotEmpty || animalAgeController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: myColors.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: myColors.lightGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: myColors.forestGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You\'ll be able to add health records in the next step.',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: myColors.forestGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
  
  Widget _buildImageUploadSection(MyColors myColors, double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.image,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Animal Photo',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isUploading)
                      const CircularProgressIndicator()
                    else
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap to upload an image',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add a clear photo of your animal for easier identification.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }
}
