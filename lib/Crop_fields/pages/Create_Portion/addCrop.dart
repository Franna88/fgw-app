import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Crop_fields/pages/Create_Portion/ui/portionInfo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../services/firebase_service.dart';

class AddCrop extends StatefulWidget {
  final String? portionId;

  const AddCrop({super.key, this.portionId});

  @override
  State<AddCrop> createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  final TextEditingController _cropFazeController =
      TextEditingController(text: 'Planting');
  final TextEditingController _dayCountController =
      TextEditingController(text: '14 days');

  String? _selectedPortion;
  String? _selectedRows;
  String? _selectedCrop;

  final List<String> _portionOptions = [];
  final List<String> _rowOptions = ['1', '2', '3', '4', '5'];
  final List<String> _cropOptions = [
    'Carrot',
    'Potato',
    'Beetroot',
    'Spinach',
    'Tomato',
    'Lettuce'
  ];

  final List<Map<String, String>> _cropInfo = [
    {
      'text': 'Estimated harvest amount',
      'amounts': '55 plants',
    },
    {
      'text': 'Planting Depth',
      'amounts': '3 cm',
    },
    {
      'text': 'Distance in row',
      'amounts': '12 cm',
    },
    {
      'text': 'Distance between row',
      'amounts': '12 cm',
    },
  ];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to avoid scheduler issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPortionData();
    });
  }

  Future<void> _loadPortionData() async {
    if (widget.portionId != null) {
      try {
        final currentUser = FirebaseService.currentUser;
        if (currentUser == null) {
          throw Exception('User not logged in');
        }

        // Loop through all fields to find the portion
        bool found = false;
        final fieldsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('cropFields')
            .get();

        for (var fieldDoc in fieldsSnapshot.docs) {
          final portionDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('cropFields')
              .doc(fieldDoc.id)
              .collection('portions')
              .doc(widget.portionId)
              .get();

          if (portionDoc.exists) {
            found = true;
            final data = portionDoc.data();
            if (data != null) {
              final portionName = data['name'] ?? 'Unknown Portion';
              final cropName = data['crop'];

              if (mounted) {
                setState(() {
                  _portionOptions.add(portionName);
                  _selectedPortion = portionName;

                  // If crop is already set, select it
                  if (cropName != null && cropName.isNotEmpty) {
                    if (_cropOptions.contains(cropName)) {
                      _selectedCrop = cropName;
                    }
                  }
                });
              }
            }
            break;
          }
        }

        if (!found && mounted) {
          setState(() {
            _selectedPortion = 'Portion not found';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Portion not found'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error loading portion: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _saveCropData() async {
    if (_selectedCrop == null || _selectedRows == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if portion is selected when portionId is not provided
    if (widget.portionId == null && _selectedPortion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a portion'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // If the portion ID is provided, update that portion with crop info
      if (widget.portionId != null) {
        // Get the current user
        final currentUser = FirebaseService.currentUser;
        if (currentUser == null) {
          throw Exception("User not logged in");
        }

        // Create row entries for the selected number of rows
        List<Map<String, dynamic>> rows = [];
        int rowCount = int.parse(_selectedRows!);

        for (int i = 1; i <= rowCount; i++) {
          rows.add({
            'rowNumber': 'Row $i',
            'progressValue': 0.0,
            'rowFaze': _cropFazeController.text,
            'tasksCompleted': 0,
            'totalTasks': 0,
            'isActive': true,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }

        // Find the field that contains this portion
        DocumentReference? portionDocRef;

        // First get all user's fields
        final fieldsQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('cropFields')
            .get();

        // For each field, check if it contains our portion
        for (var fieldDoc in fieldsQuery.docs) {
          final portionDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('cropFields')
              .doc(fieldDoc.id)
              .collection('portions')
              .doc(widget.portionId)
              .get();

          if (portionDoc.exists) {
            portionDocRef = portionDoc.reference;
            break;
          }
        }

        if (portionDocRef == null) {
          throw Exception("Portion not found in any field");
        }

        // Update portion document
        try {
          print("Updating portion with ID: ${widget.portionId}");
          print("Updating with crop: ${_selectedCrop}");
          print("Updating with rows: ${rows.length}");

          Map<String, dynamic> updateData = {
            'crop': _selectedCrop,
            'cropFaze': _cropFazeController.text,
            'dayCount': _dayCountController.text,
            'rowCount': rowCount,
            'rows': rows,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          await portionDocRef.update(updateData);
          print("Update successful");
        } catch (e) {
          print("Error updating portion: $e");
          throw e;
        }

        // Add an activity log entry
        try {
          await FirebaseFirestore.instance.collection('activity_logs').add({
            'userId': currentUser.uid,
            'action': 'added_crop',
            'details': {
              'portionId': widget.portionId,
              'cropName': _selectedCrop,
              'rowCount': rowCount,
            },
            'timestamp': DateTime.now().toIso8601String(),
            'createdAt': FieldValue.serverTimestamp(),
          });
          print("Activity log created successfully");
        } catch (e) {
          print("Error creating activity log: $e");
        }
      }

      // Return data to the caller
      if (mounted) {
        Navigator.pop(context, {
          'portion': _selectedPortion ?? '',
          'rows': _selectedRows ?? '0',
          'crop': _selectedCrop ?? '',
          'cropFaze': _cropFazeController.text,
          'dayCount': _dayCountController.text,
          'rowNumber': 'Row 1',
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        // Log the error for debugging
        print("Error in _saveCropData: $e");

        String errorMessage = 'Error saving crop data';
        if (e.toString().contains('invalid-argument')) {
          errorMessage = 'Invalid data format. Please check your inputs.';
        } else if (e.toString().contains('permission-denied')) {
          errorMessage = 'You don\'t have permission to update this portion.';
        } else if (e.toString().contains('not-found')) {
          errorMessage = 'Portion not found. It may have been deleted.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    IconData _getCropIcon() {
      if (_selectedCrop == null) return FontAwesomeIcons.seedling;

      switch (_selectedCrop!.toLowerCase()) {
        case 'carrot':
          return FontAwesomeIcons.carrot;
        case 'potato':
          return FontAwesomeIcons.circleDot;
        case 'beetroot':
          return FontAwesomeIcons.apple;
        case 'spinach':
          return FontAwesomeIcons.leaf;
        case 'tomato':
          return FontAwesomeIcons.apple;
        case 'lettuce':
          return FontAwesomeIcons.leaf;
        default:
          return FontAwesomeIcons.seedling;
      }
    }

    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Column(
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
                  CornerHeaderContainer(
                    header: 'Add New Crop',
                    hasBackArrow: true,
                  ).animate().fadeIn(duration: 300.ms),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          // Crop selection form
                          Container(
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
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section header
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.leaf,
                                        size: 16,
                                        color: myColors.forestGreen,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Crop Details',
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

                                  // Portion selection
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Portion',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      widget.portionId != null
                                          ? Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                              ),
                                              child: Text(
                                                _selectedPortion ??
                                                    'Loading portion...',
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedPortion,
                                                  hint: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16),
                                                    child: Text(
                                                      'Select Portion',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                  ),
                                                  isExpanded: true,
                                                  icon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 16),
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  items: _portionOptions.map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Text(value),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _selectedPortion =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Row count selection
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Number of Rows',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedRows,
                                            hint: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Text(
                                                'Select Number of Rows',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                            isExpanded: true,
                                            icon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            items: _rowOptions
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16),
                                                    child: Text(value),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedRows = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Crop selection
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Crop',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedCrop,
                                            hint: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Text(
                                                'Select Crop Type',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                            isExpanded: true,
                                            icon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            items: _cropOptions
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16),
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          value.toLowerCase() ==
                                                                  'carrot'
                                                              ? FontAwesomeIcons
                                                                  .carrot
                                                              : value.toLowerCase() ==
                                                                      'potato'
                                                                  ? FontAwesomeIcons
                                                                      .circleDot
                                                                  : value.toLowerCase() ==
                                                                          'beetroot'
                                                                      ? FontAwesomeIcons
                                                                          .apple
                                                                      : value.toLowerCase() ==
                                                                              'spinach'
                                                                          ? FontAwesomeIcons
                                                                              .leaf
                                                                          : value.toLowerCase() == 'tomato'
                                                                              ? FontAwesomeIcons.apple
                                                                              : FontAwesomeIcons.seedling,
                                                          size: 14,
                                                          color: myColors
                                                              .forestGreen,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(value),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedCrop = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),

                          // Crop info section
                          Container(
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
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.ruler,
                                        size: 16,
                                        color: myColors.forestGreen,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Planting Information',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  if (_selectedCrop != null)
                                    Column(
                                      children: _cropInfo
                                          .map((info) => PortionInfo(
                                                text: info['text']!,
                                                amounts: info['amounts']!,
                                              ))
                                          .toList(),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Center(
                                        child: Text(
                                          'Select a crop to see planting information',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: 0.2, end: 0),

                          // Advanced fields section
                          Container(
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
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.sliders,
                                        size: 16,
                                        color: myColors.forestGreen,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Additional Information',
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

                                  // Crop phase field
                                  _buildTextField(
                                    controller: _cropFazeController,
                                    label: 'Crop Phase',
                                    icon: FontAwesomeIcons.seedling,
                                  ),

                                  const SizedBox(height: 16),

                                  // Day count field
                                  _buildTextField(
                                    controller: _dayCountController,
                                    label: 'Growth Time',
                                    icon: FontAwesomeIcons.clock,
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                  ),

                  // Save button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: screenWidth * 0.65,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : () => _saveCropData(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myColors.forestGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              myColors.forestGreen.withOpacity(0.5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
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
                                  const Icon(Icons.save),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Save',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final myColors = MyColors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.roboto(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: FaIcon(
                  icon,
                  size: 16,
                  color: myColors.forestGreen,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cropFazeController.dispose();
    _dayCountController.dispose();
    super.dispose();
  }
}
