import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../CommonUi/Input_Fields/labeledDropDown.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class AddInventoryItem extends StatefulWidget {
  final String category;

  const AddInventoryItem({
    super.key,
    required this.category,
  });

  @override
  State<AddInventoryItem> createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends State<AddInventoryItem> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  final _costController = TextEditingController();
  
  String _selectedUnit = 'kg';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _imageFile;
  
  final _inventoryService = InventoryService();
  final _imagePicker = ImagePicker();
  final List<String> _units = ['kg', 'g', 'ton', 'pcs', 'l', 'ml', 'bags'];
  
  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error picking image: $e',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Default image paths based on category
      final String imagePath = _imageFile?.path ?? 'images/${widget.category.toLowerCase()}.png';
      
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final cost = double.tryParse(_costController.text);
      
      await _inventoryService.addItem(
        name: _nameController.text,
        category: widget.category,
        imageUrl: imagePath,
        quantity: quantity,
        unit: _selectedUnit,
        unitCost: cost,
        notes: _notesController.text,
      );
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_nameController.text} added to inventory',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: MyColors().forestGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.pop(context, true); // Return success
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error adding item: $e',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                header: 'Add ${widget.category} Item',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: _buildItemForm(myColors, screenWidth),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: _isLoading 
                  ? const CircularProgressIndicator() 
                  : CommonButton(
                      customWidth: screenWidth * 0.5,
                      customHeight: 50,
                      buttonText: 'Save Item',
                      buttonColor: myColors.yellow,
                      textColor: myColors.black,
                      onTap: _saveItem,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildItemForm(MyColors myColors, double screenWidth) {
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
                  _getCategoryIcon(),
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Item Details',
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

            // Image picker section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Image (optional)',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildImagePreview(myColors),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColors.forestGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColors.forestGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            LabeledTextField(
              label: 'Item Name*',
              hintText: 'Enter item name',
              controller: _nameController,
              validator: (value) => value == null || value.isEmpty 
                  ? 'Please enter an item name' 
                  : null,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: LabeledTextField(
                    label: 'Quantity*',
                    hintText: 'Enter amount',
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: LabeledDropdown(
                    label: 'Unit*',
                    hintText: 'Select',
                    items: _units,
                    value: _selectedUnit,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedUnit = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            LabeledTextField(
              label: 'Unit Cost (optional)',
              hintText: 'Enter cost per unit',
              controller: _costController,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 20),
            
            LabeledTextField(
              label: 'Notes (optional)',
              hintText: 'Enter additional details',
              controller: _notesController,
              lines: 3,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: myColors.forestGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important Information',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: myColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fields marked with * are required. You can update quantities anytime from the inventory list.',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: myColors.forestGreen,
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
  
  Widget _buildImagePreview(MyColors myColors) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: _imageFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.image,
                  size: 32,
                  color: Colors.grey[500],
                ),
                const SizedBox(height: 8),
                Text(
                  'No image',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
    );
  }
  
  IconData _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'crops':
        return FontAwesomeIcons.seedling;
      case 'livestock':
        return FontAwesomeIcons.cow;
      case 'pest control':
        return FontAwesomeIcons.bug;
      case 'tools/equipment':
        return FontAwesomeIcons.toolbox;
      case 'soil':
        return FontAwesomeIcons.mountain;
      case 'seeds':
        return FontAwesomeIcons.leaf;
      case 'animal feed':
        return FontAwesomeIcons.wheatAwn;
      default:
        return FontAwesomeIcons.box;
    }
  }
} 