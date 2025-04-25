import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  String? selectedField;
  String? selectedPortion;

  bool get _isFormValid => 
    selectedField != null && 
    selectedPortion != null && 
    dateController.text.isNotEmpty && 
    reminderController.text.isNotEmpty;

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
                header: 'Add Reminder',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _buildReminderCard(myColors, screenWidth),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: CommonButton(
                  customWidth: screenWidth * 0.6,
                  customHeight: 50,
                  buttonText: 'Save Reminder',
                  buttonColor: myColors.yellow,
                  textColor: myColors.black,
                  onTap: () {
                    if (_isFormValid) {
                      Navigator.pop(context, {
                        'field': selectedField!,
                        'portion': selectedPortion!,
                        'date': dateController.text,
                        'reminder': reminderController.text,
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please fill all fields",
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
  
  Widget _buildReminderCard(MyColors myColors, double screenWidth) {
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
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Reminder Details',
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
            
            LabeledDropdown(
              label: 'Field',
              hintText: 'Select a field',
              items: ['Field A', 'Field B', 'Field C', 'Field D', 'Field E'],
              onChanged: (value) {
                setState(() {
                  selectedField = value;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            LabeledDropdown(
              label: 'Portion',
              hintText: 'Select a portion',
              items: ['Portion A', 'Portion B', 'Portion C'],
              onChanged: (value) {
                setState(() {
                  selectedPortion = value;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            LabeledDatePicker(
              label: 'Reminder Date',
              hintText: 'Select a date',
              controller: dateController,
            ),
            
            const SizedBox(height: 20),
            
            LabeledTextField(
              lines: 5,
              label: 'Reminder',
              hintText: 'Enter reminder details',
              controller: reminderController,
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
                      'All fields are required. You\'ll be able to view this reminder in your reminders list.',
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
