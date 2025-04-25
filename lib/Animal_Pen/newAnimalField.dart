import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class NewAnimalField extends StatefulWidget {
  const NewAnimalField({super.key});

  @override
  State<NewAnimalField> createState() => _NewAnimalFieldState();
}

class _NewAnimalFieldState extends State<NewAnimalField> {
  final TextEditingController fieldNameController = TextEditingController();
  String? selectedAnimal;
  bool _isSaving = false;
  bool _showSuccessAnimation = false;

  String _getAnimalImage(String animal) {
    switch (animal) {
      case 'Sheep':
        return 'images/sheep.png';
      case 'Cattle':
        return 'images/cattle.png';
      case 'Pigs':
        return 'images/pig.png';
      case 'Chickens':
        return 'images/chicken.png';
      default:
        return 'images/livestock.png';
    }
  }
  
  IconData _getAnimalIcon(String? animal) {
    if (animal == null) return FontAwesomeIcons.paw;
    
    switch (animal) {
      case 'Sheep':
        return FontAwesomeIcons.pagelines;
      case 'Cattle':
        return FontAwesomeIcons.horse;
      case 'Pigs':
        return FontAwesomeIcons.piggyBank;
      case 'Chickens':
        return FontAwesomeIcons.dove;
      default:
        return FontAwesomeIcons.paw;
    }
  }

  void _saveField() {
    if (fieldNameController.text.isEmpty || selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide all the required details.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Show success animation before navigating back
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showSuccessAnimation = true;
      });
      
      // Navigate back after animation completes
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context, {
          'name': fieldNameController.text,
          'animal': selectedAnimal!,
          'image': _getAnimalImage(selectedAnimal!),
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                Container(
                  height: screenHeight - topPadding,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        myColors.forestGreen,
                        myColors.lightGreen,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const CornerHeaderContainer(
                        header: 'New Animal Field',
                        hasBackArrow: true,
                      ).animate().fadeIn(duration: 300.ms),
                      
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              // Field info card
                              _buildFieldDetailsCard(myColors, screenWidth),
                              
                              // Image upload container
                              _buildImagePreviewCard(myColors, screenWidth),
                            ],
                          ),
                        ),
                      ),
                      
                      // Save button
                      _buildSaveButton(myColors, screenWidth),
                    ],
                  ),
                ),
              ],
            ),
            
            // Success animation overlay
            if (_showSuccessAnimation)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ).animate().scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1, 1),
                            duration: 400.ms,
                            curve: Curves.elasticOut,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Field Created!',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 200.ms),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFieldDetailsCard(MyColors myColors, double screenWidth) {
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(bottom: 20),
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
            // Section header
            Row(
              children: [
                FaIcon(
                  selectedAnimal != null
                      ? _getAnimalIcon(selectedAnimal)
                      : FontAwesomeIcons.seedling,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 12),
                Text(
                  'Field Details',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 20),
            
            // Field name input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: myColors.forestGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Field Name',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    color: Colors.grey[50],
                  ),
                  child: TextField(
                    controller: fieldNameController,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: myColors.forestGreen,
                        ),
                      ),
                      hintText: 'Enter field name',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Animal type dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.paw,
                      size: 16,
                      color: myColors.forestGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Animal Type',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    color: Colors.grey[50],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedAnimal,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Select animal type',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      isExpanded: true,
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      items: ['Sheep', 'Cattle', 'Pigs', 'Chickens']
                          .map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  FaIcon(
                                    _getAnimalIcon(value),
                                    size: 16,
                                    color: myColors.forestGreen,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    value,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedAnimal = newValue;
                        });
                      },
                      dropdownColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            
            // Information box
            if (selectedAnimal != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
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
                        size: 16,
                        color: myColors.forestGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You selected ${selectedAnimal!} for this field. You can add specific animals later.',
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
  
  Widget _buildImagePreviewCard(MyColors myColors, double screenWidth) {
    return Container(
      width: screenWidth * 0.9,
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
                  Icons.image_outlined,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 12),
                Text(
                  'Reference Image',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 20),
            
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedAnimal != null)
                    Image.asset(
                      _getAnimalImage(selectedAnimal!),
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return FaIcon(
                          _getAnimalIcon(selectedAnimal),
                          size: 60,
                          color: Colors.grey[400],
                        );
                      },
                    ).animate().fadeIn(duration: 300.ms)
                  else
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selectedAnimal != null 
                          ? myColors.lightGreen.withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      selectedAnimal != null
                          ? selectedAnimal!
                          : 'Select an animal type to see preview',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: selectedAnimal != null
                            ? myColors.forestGreen
                            : Colors.grey[600],
                        fontWeight: selectedAnimal != null
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A default image will be used based on your animal selection. You can change this later.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
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

  Widget _buildSaveButton(MyColors myColors, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: screenWidth * 0.75,
        height: 55,
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveField,
          style: ElevatedButton.styleFrom(
            backgroundColor: myColors.forestGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: myColors.forestGreen.withOpacity(0.5),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: _isSaving
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'Save Field',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
