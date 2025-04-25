import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class TaskCreateFieldSelect extends StatefulWidget {
  const TaskCreateFieldSelect({super.key});

  @override
  State<TaskCreateFieldSelect> createState() => _TaskCreateFieldSelectState();
}

class _TaskCreateFieldSelectState extends State<TaskCreateFieldSelect> {
  // Sample data for dropdown demonstration
  final List<String> _fields = ['Field A', 'Field B', 'Field C'];
  final List<String> _portions = ['Portion 1', 'Portion 2', 'North Section'];
  
  String? _selectedField;
  String? _selectedPortion;
  
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            const FgwTopBar(title: 'Create Task'),
            
            // Content area
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 10),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: myColors.forestGreen,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Select Location',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                      
                      // Description
                      ModernCard(
                        color: myColors.lightGreen.withOpacity(0.1),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: myColors.forestGreen,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tasks are tied to specific locations on your farm. Select a field and portion to continue.',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Dropdowns
                      Text(
                        'Field',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16, 
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Select Field', style: TextStyle(color: Colors.grey[600])),
                            value: _selectedField,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: _fields.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedField = value;
                              });
                            },
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Portion',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16, 
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Select Portion', style: TextStyle(color: Colors.grey[600])),
                            value: _selectedPortion,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: _portions.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedPortion = value;
                              });
                            },
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -1),
              blurRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: myColors.forestGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: myColors.forestGreen),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedField == null || _selectedPortion == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select both a field and portion'),
                        ),
                      );
                      return;
                    }
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskCreateDetails(
                          selectedField: _selectedField!,
                          selectedPortion: _selectedPortion!,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
