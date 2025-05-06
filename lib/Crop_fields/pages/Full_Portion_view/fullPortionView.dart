import 'package:farming_gods_way/Crop_fields/pages/Full_Portion_view/ui/portionRowTaskItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';
import '../../../Tasks/Tasks_List_Page/tasksListPage.dart';
import '../Create_Portion/ui/portionInfo.dart';

class FullPortionView extends StatefulWidget {
  final String portionId;

  const FullPortionView({super.key, required this.portionId});

  @override
  State<FullPortionView> createState() => _FullPortionViewState();
}

class _FullPortionViewState extends State<FullPortionView> {
  bool _isLoading = true;
  String _portionType = 'Root Type';
  String _portionName = 'Portion A';
  String _crop = 'Carrot';
  int _rowCount = 5;
  // Field info
  String _foundFieldId = '';
  String _foundFieldName = 'Unknown Field';

  // Data for rows
  List<Map<String, dynamic>> _rows = [];

  @override
  void initState() {
    super.initState();
    // Validation check for portionId
    if (widget.portionId.isEmpty) {
      // Show error in next frame to avoid build issues
      Future.microtask(() {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Portion ID cannot be empty'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      return;
    }

    // Use post-frame callback to avoid scheduler issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPortionData();
    });
  }

  Future<void> _loadPortionData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Check if we already know the field ID
      if (_foundFieldId.isNotEmpty) {
        // We know which field this portion belongs to, so load it directly
        final portionDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('cropFields')
            .doc(_foundFieldId)
            .collection('portions')
            .doc(widget.portionId)
            .get();

        if (!portionDoc.exists) {
          throw Exception('Portion not found');
        }

        final data = portionDoc.data();
        if (data != null) {
          setState(() {
            _portionName = data['name'] ?? 'Unknown Portion';
            _portionType = data['portionType'] ?? 'Unknown Type';
            _crop = data['crop'] ?? 'No Crop';

            // Load rows if they exist
            if (data['rows'] != null) {
              _rows = List<Map<String, dynamic>>.from(data['rows']);
              _rowCount = _rows.length;
            } else {
              _rows = [];
              _rowCount = 0;
            }

            _isLoading = false;
          });
          return;
        }
      }

      // If we don't know the field ID, search through all fields
      final fieldsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .get();

      if (fieldsSnapshot.docs.isEmpty) {
        throw Exception('No fields found');
      }

      // Search through all fields for the portion
      bool found = false;
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
          final data = portionDoc.data();
          if (data != null) {
            setState(() {
              // Store field information
              _foundFieldId = fieldDoc.id;
              _foundFieldName = fieldDoc.data()['name'] ?? 'Unknown Field';

              _portionName = data['name'] ?? 'Unknown Portion';
              _portionType = data['portionType'] ?? 'Unknown Type';
              _crop = data['crop'] ?? 'No Crop';

              // Load rows if they exist
              if (data['rows'] != null) {
                _rows = List<Map<String, dynamic>>.from(data['rows']);
                _rowCount = _rows.length;
              } else {
                _rows = [];
                _rowCount = 0;
              }

              _isLoading = false;
              found = true;
            });
            break;
          }
        }
      }

      if (!found) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Portion with ID "${widget.portionId}" not found'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading portion data: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToTaskList(String rowNumber) {
    setState(() {
      _isLoading = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksListPage(
          fieldId: _foundFieldId,
          portionId: widget.portionId,
          rowNumber: rowNumber,
          fieldName: _foundFieldName,
          portionName: _portionName,
        ),
      ),
    ).then((_) {
      setState(() {
        _isLoading = false;
      });

      // Refresh data when returning from task list
      _loadPortionData();
    });
  }

  String _getImagePath() {
    switch (_portionType.toLowerCase()) {
      case 'root type':
        return 'images/carrot.png';
      case 'leaf type':
        return 'images/spinach.png';
      case 'fruit type':
        return 'images/apple.png';
      default:
        return 'images/carrot.png';
    }
  }

  // Calculate overall progress
  double get _overallProgress {
    if (_rows.isEmpty) return 0.0;

    final totalCompleted =
        _rows.fold<int>(0, (sum, row) => sum + (row['tasksCompleted'] as int));
    final totalTasks =
        _rows.fold<int>(0, (sum, row) => sum + (row['totalTasks'] as int));

    return totalTasks > 0 ? totalCompleted / totalTasks : 0.0;
  }

  // Add new row to portion
  Future<void> _addRow() async {
    try {
      // Create new row data
      final newRow = {
        'rowNumber': 'Row ${_rows.length + 1}',
        'progressValue': 0.0,
        'rowFaze': 'Planting',
        'tasksCompleted': 0,
        'totalTasks': 0,
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Make sure we have the field ID
      if (_foundFieldId.isEmpty) {
        throw Exception('Field ID is empty. Please reload the page.');
      }

      // We already have the field ID, so directly update the portion
      final portionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(_foundFieldId)
          .collection('portions')
          .doc(widget.portionId);

      // Verify that both IDs are valid
      if (widget.portionId.isEmpty) {
        throw Exception('Portion ID cannot be empty');
      }

      // Get current rows
      final portionSnapshot = await portionRef.get();
      if (!portionSnapshot.exists) {
        throw Exception('Portion not found');
      }

      final portionData = portionSnapshot.data();
      if (portionData == null) {
        throw Exception('Portion data not found');
      }

      List<Map<String, dynamic>> updatedRows = [];
      if (portionData['rows'] != null) {
        updatedRows = List<Map<String, dynamic>>.from(portionData['rows']);
      }

      // Add new row
      updatedRows.add(newRow);

      // Update portion with new row
      await portionRef.update({
        'rows': updatedRows,
        'rowCount': updatedRows.length,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Refresh UI
      setState(() {
        _rows.add(newRow);
        _rowCount = _rows.length;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Row added successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding row: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          header: _portionName,
                          hasBackArrow: true,
                        ).animate().fadeIn(duration: 300.ms),

                        // Main content area
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                // Portion info card
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header section with type and image
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Type badge
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: myColors.lightGreen
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                      color:
                                                          myColors.lightGreen,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    _portionType,
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          myColors.forestGreen,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(height: 16),

                                                // Row count
                                                Text(
                                                  '$_rowCount Rows',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 8),

                                                // Crop name
                                                Row(
                                                  children: [
                                                    FaIcon(
                                                      _portionType
                                                              .toLowerCase()
                                                              .contains('root')
                                                          ? FontAwesomeIcons
                                                              .carrot
                                                          : _portionType
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'leaf')
                                                              ? FontAwesomeIcons
                                                                  .seedling
                                                              : FontAwesomeIcons
                                                                  .apple,
                                                      size: 16,
                                                      color:
                                                          myColors.forestGreen,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      _crop,
                                                      style: GoogleFonts
                                                          .robotoSlab(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // Crop image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.asset(
                                                _getImagePath(),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),
                                        const Divider(),
                                        const SizedBox(height: 16),

                                        // Progress section
                                        Text(
                                          'Overall Progress',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: LinearProgressIndicator(
                                                  value: _overallProgress,
                                                  minHeight: 10,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    _overallProgress >= 1.0
                                                        ? myColors.green
                                                        : _overallProgress >=
                                                                0.5
                                                            ? myColors.yellow
                                                            : myColors
                                                                .lightBlue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${(_overallProgress * 100).toInt()}%',
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: _overallProgress >= 1.0
                                                    ? myColors.green
                                                    : _overallProgress >= 0.5
                                                        ? myColors.yellow
                                                        : myColors.lightBlue,
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

                                const SizedBox(height: 20),

                                // Planting info card
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        PortionInfo(
                                          text: 'Estimated harvest amount',
                                          amounts: '55 plants',
                                        ),
                                        PortionInfo(
                                          text: 'Planting Depth',
                                          amounts: '3 cm',
                                        ),
                                        PortionInfo(
                                          text: 'Distance in row',
                                          amounts: '12 cm',
                                        ),
                                        PortionInfo(
                                          text: 'Distance between row',
                                          amounts: '12 cm',
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .slideY(begin: 0.2, end: 0),

                                const SizedBox(height: 20),

                                // Row tasks header
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Row Tasks',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.tasks,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'All Rows',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 600.ms),

                                const SizedBox(height: 12),

                                // Row tasks list
                                Container(
                                  width: screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: _rows.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.grid_3x3,
                                                  size: 40,
                                                  color: Colors.white
                                                      .withOpacity(0.6),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'No rows available yet',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Tap + to add your first row',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(16),
                                          itemCount: _rows.length,
                                          itemBuilder: (context, index) {
                                            final row = _rows[index];
                                            return GestureDetector(
                                              onTap: () => _navigateToTaskList(
                                                  row['rowNumber'] ??
                                                      'Row ${index + 1}'),
                                              child: PortionRowTaskItem(
                                                row: row['rowNumber'] ??
                                                    'Row ${index + 1}',
                                                progressValue:
                                                    row['progressValue'] ?? 0.0,
                                                rowFaze: row['rowFaze'] ??
                                                    'Planting',
                                                onTap: () =>
                                                    _navigateToTaskList(
                                                        row['rowNumber'] ??
                                                            'Row ${index + 1}'),
                                              ).animate().fadeIn(
                                                    duration: 400.ms,
                                                    delay: 50.ms * index,
                                                  ),
                                            );
                                          },
                                        ),
                                ).animate().fadeIn(duration: 700.ms),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRow,
        backgroundColor: myColors.forestGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().fadeIn(duration: 800.ms).scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 300.ms),
    );
  }
}
