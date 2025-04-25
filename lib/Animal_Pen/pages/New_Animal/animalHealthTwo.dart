import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';
import '../animalProfiles/animalProfilesList.dart';

class AnimalHealthTwo extends StatefulWidget {
  const AnimalHealthTwo({super.key});

  @override
  State<AnimalHealthTwo> createState() => _AnimalHealthTwoState();
}

class _AnimalHealthTwoState extends State<AnimalHealthTwo> {
  final ongoingHealthController = TextEditingController();
  final currentWeightController = TextEditingController();
  final currentSizeController = TextEditingController();
  
  @override
  void dispose() {
    ongoingHealthController.dispose();
    currentWeightController.dispose();
    currentSizeController.dispose();
    super.dispose();
  }
  
  bool get _isFormValid =>
      currentWeightController.text.isNotEmpty && currentSizeController.text.isNotEmpty;

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
                header: 'Current Health Status',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _buildCurrentHealthCard(myColors, screenWidth),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: CommonButton(
                  customWidth: screenWidth * 0.5,
                  customHeight: 50,
                  buttonText: 'Save',
                  buttonColor: myColors.yellow,
                  textColor: myColors.black,
                  onTap: () {
                    // Check if form is valid before proceeding
                    if (_isFormValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnimalProfilesList(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please fill in the required fields',
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
  
  Widget _buildCurrentHealthCard(MyColors myColors, double screenWidth) {
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
                  FontAwesomeIcons.weightScale,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Current Measurements',
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
              label: 'Ongoing Health Issues',
              hintText: 'Enter any current health concerns',
              controller: ongoingHealthController,
              lines: 5,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'Current Weight*',
                    hintText: 'e.g. 250 kg',
                    controller: currentWeightController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LabeledTextField(
                    label: 'Current Size*',
                    hintText: 'e.g. 1.2 m',
                    controller: currentSizeController,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
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
                      'Fields marked with * are required. This information helps track your animal\'s growth over time.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: myColors.forestGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}