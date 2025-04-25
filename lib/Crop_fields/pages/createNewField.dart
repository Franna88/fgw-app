import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class CreateNewField extends StatefulWidget {
  const CreateNewField({super.key});

  @override
  State<CreateNewField> createState() => _CreateNewFieldState();
}

class _CreateNewFieldState extends State<CreateNewField> {
  final TextEditingController fieldNameController = TextEditingController();
  bool _hasImage = false;

  @override
  void dispose() {
    fieldNameController.dispose();
    super.dispose();
  }

  void _saveField() {
    if (fieldNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a field name')),
      );
      return;
    }
    
    // Print debug information
    print('Creating field with name: ${fieldNameController.text}');
    
    // Create a Map<String, dynamic> to be compatible with the parent's expectations
    final field = <String, dynamic>{
      'name': fieldNameController.text,
      'image': 'images/cropField.png', // Default image path
      'portions': [], // Initialize with empty portions list
      'lastModified': DateTime.now(),
    };
    
    print('Field data: $field');
    Navigator.pop(context, field);
    print('Navigated back with field data');
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            const FgwTopBar(title: 'New Field'),
            
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
                                FontAwesomeIcons.leaf,
                                color: myColors.forestGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Create New Field',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                        
                        // Field name input
                        Text(
                          'Field Name',
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
                            controller: fieldNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter a name for this field',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                        
                        const SizedBox(height: 24),
                        
                        // Field image section
                        Text(
                          'Field Image (Optional)',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                        const SizedBox(height: 8),
                        
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _hasImage = !_hasImage;
                            });
                          },
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _hasImage ? null : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              image: _hasImage ? const DecorationImage(
                                image: AssetImage('images/cropField.png'),
                                fit: BoxFit.cover,
                              ) : null,
                            ),
                            child: _hasImage ? null : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add a field image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                        
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
                                  'After creating a field, you can add portions to it and manage crops within each portion',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
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
                  onPressed: _saveField,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Create Field'),
                ),
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 400.ms, delay: 600.ms),
    );
  }
}
