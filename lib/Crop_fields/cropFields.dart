import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:farming_gods_way/Crop_fields/ui/fieldListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';
import 'pages/createNewField.dart';
import 'pages/cropFieldView.dart';

class CropFields extends StatefulWidget {
  const CropFields({super.key});

  @override
  State<CropFields> createState() => _CropFieldsState();
}

class _CropFieldsState extends State<CropFields> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> fields = [];
  bool _isLoading = true;
  late AnimationController _fabController;
  
  // Sample field images for demonstration
  final List<String> _fieldImages = [
    'images/cropField.png',
    'images/cropField.png',
    'images/cropField.png',
  ];
  
  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Simulate loading data (in a real app, this would come from a database)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _fabController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _navigateToCreateField() async {
    print('Navigating to create field screen');
    final newField = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNewField()),
    );

    print('Returned from create field screen with data: $newField');
    if (newField != null && mounted) {
      print('Adding new field to list');
      setState(() {
        // Field already includes portions and lastModified from the CreateNewField
        fields.add(newField);
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newField['name']} created successfully')),
      );
      print('Field added successfully: ${fields.length} fields total');
    } else {
      print('Field creation cancelled or component unmounted');
    }
  }

  void _navigateToFieldView(Map<String, dynamic> field) {
    // Convert to Map<String, String> since that's what CropFieldView expects
    final convertedField = <String, String>{
      'name': field['name'] as String,
      'image': field['image'] as String,
    };
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropFieldView(field: convertedField),
      ),
    ).then((result) {
      // Handle any updates when returning from field view
      if (result != null && result['updated'] == true && mounted) {
        setState(() {
          // Refresh the fields list
          final index = fields.indexWhere((f) => f['name'] == result['name']);
          if (index != -1) {
            fields[index] = result;
          }
        });
      }
    });
  }
  
  void _deleteField(int index) {
    final fieldName = fields[index]['name'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Field'),
        content: Text('Are you sure you want to delete "$fieldName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                fields.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$fieldName deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            const FgwTopBar(title: 'Crop Fields'),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToCreateField,
                      icon: Icon(Icons.add, color: myColors.black),
                      label: Text(
                        'Add Field',
                        style: TextStyle(color: myColors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myColors.yellow,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: myColors.offWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: myColors.black,
                      ),
                      onPressed: () {
                        // Filter functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filter options coming soon')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : fields.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: fields.length,
                            itemBuilder: (context, index) {
                              final field = fields[index];
                              
                              // Add some visual info for each field
                              final portions = field['portions'] ?? [];
                              final portionCount = portions.length;
                              final lastModified = field['lastModified'] ?? DateTime.now();
                              
                              // Use animate extension method directly on widget
                              return Dismissible(
                                key: Key(field['name']),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  _deleteField(index);
                                },
                                confirmDismiss: (direction) async {
                                  bool delete = false;
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Field'),
                                      content: Text('Are you sure you want to delete "${field['name']}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            delete = true;
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return delete;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ModernCard(
                                    onTap: () => _navigateToFieldView(field),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Field header
                                        Row(
                                          children: [
                                            // Field image or icon
                                            Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: myColors.lightGreen.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: AssetImage(field['image']!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            
                                            const SizedBox(width: 16),
                                            
                                            // Field details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    field['name']!,
                                                    style: GoogleFonts.robotoSlab(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.scatter_plot,
                                                        size: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        portionCount > 0
                                                            ? '$portionCount Portions'
                                                            : 'No portions added yet',
                                                        style: TextStyle(
                                                          color: Colors.grey[600],
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            // Arrow icon
                                            Container(
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                color: myColors.lightGreen.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                                color: myColors.forestGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        if (portionCount > 0) ...[
                                          const SizedBox(height: 12),
                                          const Divider(),
                                          const SizedBox(height: 8),
                                          
                                          // Portions summary
                                          Text(
                                            'Portions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to view and manage portions of this field',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ).animate(
                                  delay: Duration(milliseconds: 50 * index),
                                  effects: [
                                    FadeEffect(duration: Duration(milliseconds: 400)),
                                    SlideEffect(
                                      begin: Offset(0, 0.2), 
                                      end: Offset.zero,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeOutQuad,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: fields.isNotEmpty 
        ? ScaleTransition(
            scale: _fabController,
            child: FloatingActionButton.extended(
              backgroundColor: myColors.lightGreen,
              onPressed: _navigateToCreateField,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Field', style: TextStyle(color: Colors.white)),
            ),
          )
        : null,
    );
  }
  
  Widget _buildEmptyState() {
    // Create widget first, then apply animations
    print('Building empty state widget');
    final myColors = MyColors();
    
    Widget content = Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.seedling,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Fields Yet',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first field to start managing your crops',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              print('Add First Field button pressed');
              _navigateToCreateField();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add First Field'),
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.forestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
    
    // Apply animations and return
    return Center(
      child: content.animate()
        .fadeIn(duration: 600.ms)
        .moveY(begin: 10, end: 0, duration: 600.ms, curve: Curves.easeOutQuad),
    );
  }
}