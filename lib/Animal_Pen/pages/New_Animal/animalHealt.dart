import 'package:farming_gods_way/Animal_Pen/pages/New_Animal/animalHealthTwo.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AnimalHealth extends StatefulWidget {
  const AnimalHealth({super.key});

  @override
  State<AnimalHealth> createState() => _AnimalHealthState();
}

class _AnimalHealthState extends State<AnimalHealth> {
  final medHistoryController = TextEditingController();
  final recentTreatmentsController = TextEditingController();
  final vacDateController = TextEditingController();
  
  @override
  void dispose() {
    medHistoryController.dispose();
    recentTreatmentsController.dispose();
    vacDateController.dispose();
    super.dispose();
  }
  
  bool get _isFormValid =>
      vacDateController.text.isNotEmpty;

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
                header: 'Animal Health Records',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _buildHealthRecordsCard(myColors, screenWidth),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnimalHealthTwo(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHealthRecordsCard(MyColors myColors, double screenWidth) {
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
                  FontAwesomeIcons.heartPulse,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Health Information',
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
            
            LabeledDatePicker(
              label: 'Vaccination Date',
              hintText: 'Select date',
              controller: vacDateController,
            ),
            
            const SizedBox(height: 20),
            
            LabeledTextField(
              label: 'Medical History',
              hintText: 'Enter any past medical conditions or treatments',
              controller: medHistoryController,
              lines: 5,
            ),
            
            const SizedBox(height: 20),
            
            LabeledTextField(
              label: 'Recent Treatments',
              hintText: 'Enter any recent medical treatments',
              controller: recentTreatmentsController,
              lines: 5,
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
                      'In the next step, you\'ll be able to add current health status and measurements.',
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
