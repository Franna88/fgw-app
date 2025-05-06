import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class TaskCreateFieldSelect extends StatefulWidget {
  final String? preSelectedFieldId;
  final String? preSelectedPortionId;
  final String? preSelectedFieldName;
  final String? preSelectedPortionName;
  final String? preSelectedRowNumber;

  const TaskCreateFieldSelect({
    super.key,
    this.preSelectedFieldId,
    this.preSelectedPortionId,
    this.preSelectedFieldName,
    this.preSelectedPortionName,
    this.preSelectedRowNumber,
  });

  @override
  State<TaskCreateFieldSelect> createState() => _TaskCreateFieldSelectState();
}

class _TaskCreateFieldSelectState extends State<TaskCreateFieldSelect> {
  bool _isLoading = true;

  // Field data
  List<Map<String, dynamic>> _fields = [];
  List<Map<String, dynamic>> _portions = [];
  List<String> _rowNumbers = [];

  // Selected values
  String? _selectedFieldId;
  String? _selectedPortionId;
  String? _selectedFieldName;
  String? _selectedPortionName;
  String? _selectedRowNumber;

  @override
  void initState() {
    super.initState();

    // Set pre-selected values if they exist
    _selectedFieldId = widget.preSelectedFieldId;
    _selectedPortionId = widget.preSelectedPortionId;
    _selectedFieldName = widget.preSelectedFieldName;
    _selectedPortionName = widget.preSelectedPortionName;
    _selectedRowNumber = widget.preSelectedRowNumber;

    // Load data
    _loadFieldsAndPortions();
  }

  Future<void> _loadFieldsAndPortions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Load fields
      final fieldsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .get();

      _fields = fieldsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed Field',
        };
      }).toList();

      // If we have a pre-selected field, load its portions
      if (_selectedFieldId != null) {
        await _loadPortionsForField(_selectedFieldId!);

        // If we have a pre-selected portion, load its rows
        if (_selectedPortionId != null) {
          await _loadRowsForPortion(_selectedFieldId!, _selectedPortionId!);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading fields: $e');
      setState(() {
        _isLoading = false;
        // Provide some sample data if there's an error
        _fields = [
          {'id': 'sample1', 'name': 'Field A'},
          {'id': 'sample2', 'name': 'Field B'},
          {'id': 'sample3', 'name': 'Field C'},
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading fields: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadPortionsForField(String fieldId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final portionsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(fieldId)
          .collection('portions')
          .get();

      setState(() {
        _portions = portionsSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unnamed Portion',
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading portions: $e');
      // Provide sample portions if there's an error
      setState(() {
        _portions = [
          {'id': 'portion1', 'name': 'Portion 1'},
          {'id': 'portion2', 'name': 'Portion 2'},
        ];
      });
    }
  }

  Future<void> _loadRowsForPortion(String fieldId, String portionId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final portionDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(fieldId)
          .collection('portions')
          .doc(portionId)
          .get();

      if (portionDoc.exists) {
        final data = portionDoc.data();
        if (data != null && data['rows'] != null) {
          List<dynamic> rows = data['rows'];

          // Extract row numbers from rows
          setState(() {
            _rowNumbers =
                rows.map((row) => row['rowNumber'] as String).toList();
          });
        } else {
          setState(() {
            _rowNumbers = [];
          });
        }
      }
    } catch (e) {
      print('Error loading rows: $e');
      setState(() {
        _rowNumbers = [];
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30, top: 10),
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
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.2, end: 0),

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
                                      _selectedRowNumber != null
                                          ? 'Creating a task for ${_selectedPortionName}, ${_selectedRowNumber}'
                                          : 'Tasks are tied to specific locations on your farm. Select a field, portion, and row to continue.',
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

                            // Field dropdown
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Select Field',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  value: _selectedFieldId,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: _fields.map((field) {
                                    return DropdownMenuItem<String>(
                                      value: field['id'],
                                      child: Text(field['name']),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedFieldId = value;
                                      _selectedPortionId =
                                          null; // Reset portion selection
                                      _selectedRowNumber =
                                          null; // Reset row selection
                                      _rowNumbers = []; // Clear row numbers

                                      // Find the selected field name
                                      if (value != null) {
                                        final selectedField =
                                            _fields.firstWhere(
                                          (field) => field['id'] == value,
                                          orElse: () =>
                                              {'name': 'Unknown Field'},
                                        );
                                        _selectedFieldName =
                                            selectedField['name'];

                                        // Load portions for this field
                                        _loadPortionsForField(value);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                            const SizedBox(height: 24),

                            // Portion dropdown
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Select Portion',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  value: _selectedPortionId,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: _portions.map((portion) {
                                    return DropdownMenuItem<String>(
                                      value: portion['id'],
                                      child: Text(portion['name']),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedPortionId = value;
                                      _selectedRowNumber =
                                          null; // Reset row selection

                                      // Find the selected portion name
                                      if (value != null) {
                                        final selectedPortion =
                                            _portions.firstWhere(
                                          (portion) => portion['id'] == value,
                                          orElse: () =>
                                              {'name': 'Unknown Portion'},
                                        );
                                        _selectedPortionName =
                                            selectedPortion['name'];

                                        // Load rows for this portion
                                        if (_selectedFieldId != null) {
                                          _loadRowsForPortion(
                                              _selectedFieldId!, value);
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                            // Row dropdown (only visible if portion is selected)
                            if (_selectedPortionId != null) ...[
                              const SizedBox(height: 24),
                              Text(
                                'Row',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('Select Row',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                    value: _selectedRowNumber,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: _rowNumbers.map((rowNumber) {
                                      return DropdownMenuItem<String>(
                                        value: rowNumber,
                                        child: Text(rowNumber),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedRowNumber = value;
                                      });
                                    },
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms, delay: 300.ms),
                            ],

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
                    if (_selectedFieldId == null ||
                        _selectedPortionId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please select both a field and portion'),
                        ),
                      );
                      return;
                    }

                    // For portions with rows, require row selection
                    if (_rowNumbers.isNotEmpty && _selectedRowNumber == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a row'),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskCreateDetails(
                          fieldId: _selectedFieldId!,
                          portionId: _selectedPortionId!,
                          fieldName: _selectedFieldName ?? 'Unknown Field',
                          portionName:
                              _selectedPortionName ?? 'Unknown Portion',
                          rowNumber: _selectedRowNumber,
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
