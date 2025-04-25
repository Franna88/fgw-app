import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/colors.dart';

class NewPortion extends StatefulWidget {
  const NewPortion({super.key});

  @override
  State<NewPortion> createState() => _NewPortionState();
}

class _NewPortionState extends State<NewPortion> {
  final TextEditingController _portionNameController = TextEditingController();
  final TextEditingController _rowLengthController = TextEditingController();
  String? _selectedPortionType;
  
  final List<String> _portionTypes = [
    'Leaf type', 
    'Root type', 
    'Fruit type',
    'Grain type',
    'Mixed type',
  ];
  
  @override
  void dispose() {
    _portionNameController.dispose();
    _rowLengthController.dispose();
    super.dispose();
  }
  
  bool _validateInputs() {
    if (_portionNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a portion name')),
      );
      return false;
    }
    
    if (_rowLengthController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a row length')),
      );
      return false;
    }
    
    if (_selectedPortionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a portion type')),
      );
      return false;
    }
    
    return true;
  }
  
  void _savePortion() {
    if (_validateInputs()) {
      Navigator.pop(context, {
        'portionName': _portionNameController.text,
        'rowLength': _rowLengthController.text,
        'portionType': _selectedPortionType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            const FgwTopBar(title: 'New Portion'),
            
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24, top: 8),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.objectGroup,
                                color: myColors.forestGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Create New Portion',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                        
                        // Portion name input
                        Text(
                          'Portion Name',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                        const SizedBox(height: 8),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _portionNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter a name for this portion',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                        
                        const SizedBox(height: 20),
                        
                        // Row length input
                        Text(
                          'Row Length',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                        const SizedBox(height: 8),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _rowLengthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter row length (e.g., 100m)',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              suffixText: 'm',
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                        
                        const SizedBox(height: 20),
                        
                        // Portion type dropdown
                        Text(
                          'Portion Type',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                        const SizedBox(height: 8),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPortionType,
                              isExpanded: true,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Select portion type',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              borderRadius: BorderRadius.circular(12),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                              items: _portionTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Row(
                                    children: [
                                      _getPortionTypeIcon(type),
                                      const SizedBox(width: 12),
                                      Text(type),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPortionType = value;
                                });
                              },
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                        
                        const SizedBox(height: 24),
                        
                        // Help text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: myColors.lightGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: myColors.lightGreen.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: myColors.forestGreen,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Once you create a portion, you can add specific crops to it and track their progress.',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
                      ],
                    ),
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
                  onPressed: _savePortion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Create Portion'),
                ),
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 400.ms, delay: 800.ms),
    );
  }
  
  Widget _getPortionTypeIcon(String type) {
    final myColors = MyColors();
    IconData iconData;
    
    switch (type.toLowerCase()) {
      case 'leaf type':
        iconData = FontAwesomeIcons.leaf;
        break;
      case 'root type':
        iconData = FontAwesomeIcons.carrot;
        break;
      case 'fruit type':
        iconData = FontAwesomeIcons.apple;
        break;
      case 'grain type':
        iconData = FontAwesomeIcons.wheatAwn;
        break;
      default:
        iconData = FontAwesomeIcons.seedling;
    }
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: myColors.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: FaIcon(
        iconData,
        size: 12,
        color: myColors.forestGreen,
      ),
    );
  }
}
