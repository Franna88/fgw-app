import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class TaskCreateDetails extends StatefulWidget {
  final String fieldId;
  final String portionId;
  final String fieldName;
  final String portionName;
  final String? rowNumber;

  const TaskCreateDetails({
    super.key,
    required this.fieldId,
    required this.portionId,
    required this.fieldName,
    required this.portionName,
    this.rowNumber,
  });

  @override
  State<TaskCreateDetails> createState() => _TaskCreateDetailsState();
}

class _TaskCreateDetailsState extends State<TaskCreateDetails> {
  final TextEditingController _taskController = TextEditingController();
  bool _isImportant = false;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3));

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors().forestGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  // Get user-specific collection reference
  CollectionReference _getUserTasksCollection() {
    final userId = FirebaseService.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks');
  }

  Future<void> _createTask() async {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task description')),
      );
      return;
    }

    try {
      // Check if user is logged in
      final userId = FirebaseService.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to create a task')),
        );
        return;
      }

      // Create the new task in the user's tasks collection
      final taskRef = _getUserTasksCollection().doc();
      final newTask = {
        'title': _taskController.text.trim(),
        'description': _taskController.text.trim(),
        'isHighPriority': _isImportant,
        'priority': _isImportant ? 'High' : 'Medium',
        'dueDate': Timestamp.fromDate(_dueDate),
        'createdAt': FieldValue.serverTimestamp(),
        'isCompleted': false,
        'fieldId': widget.fieldId,
        'portionId': widget.portionId,
        'fieldName': widget.fieldName,
        'portionName': widget.portionName,
        'rowNumber': widget.rowNumber,
        'cropType': '', // You might want to add a field to capture this
        'userId':
            userId, // Store user ID in the document for additional security
      };

      // Save the task
      await taskRef.set(newTask);

      // Update the portion's row task count
      if (widget.rowNumber != null) {
        final portionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cropFields')
            .doc(widget.fieldId)
            .collection('portions')
            .doc(widget.portionId);

        final portionDoc = await portionRef.get();
        if (portionDoc.exists) {
          final portionData = portionDoc.data();
          if (portionData != null && portionData['rows'] != null) {
            final rows = List<dynamic>.from(portionData['rows']);

            // Find the row
            final rowIndex = rows.indexWhere(
                (row) => row['rowNumber'].toString() == widget.rowNumber);

            if (rowIndex != -1) {
              // Update existing row
              rows[rowIndex]['totalTasks'] =
                  (rows[rowIndex]['totalTasks'] ?? 0) + 1;
              rows[rowIndex]['updatedAt'] = DateTime.now().toIso8601String();

              // Recalculate progress
              final tasksCompleted = rows[rowIndex]['tasksCompleted'] ?? 0;
              final totalTasks = rows[rowIndex]['totalTasks'];
              final progressValue =
                  totalTasks > 0 ? tasksCompleted / totalTasks : 0.0;
              rows[rowIndex]['progressValue'] = progressValue;

              // Update the portion
              await portionRef.update({
                'rows': rows,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            }
          }
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully!')),
      );

      // Pop twice to go back to the main tasks screen
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create task: $e')),
      );
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
            const FgwTopBar(title: 'Task Details'),
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
                        // Location info
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
                                Icons.location_on,
                                color: myColors.forestGreen,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Field: ${widget.fieldName}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Portion: ${widget.portionName}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    if (widget.rowNumber != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Row: ${widget.rowNumber}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 20),

                        // Header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24, top: 8),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.clipboardList,
                                color: myColors.forestGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Define Your Task',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                        // Task description field
                        Text(
                          'Task Description',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
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
                            controller: _taskController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Describe what needs to be done...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                        const SizedBox(height: 24),

                        // Due date selector
                        Text(
                          'Due Date',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: myColors.forestGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

                        const SizedBox(height: 24),

                        // Reference image section
                        Text(
                          'Reference Image (Optional)',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                        const SizedBox(height: 8),
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Image selection logic
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add an image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                        const SizedBox(height: 24),

                        // Priority checkbox
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isImportant = !_isImportant;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: _isImportant
                                  ? myColors.lightGreen.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isImportant
                                    ? myColors.forestGreen
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _isImportant,
                                    activeColor: myColors.forestGreen,
                                    onChanged: (value) {
                                      setState(() {
                                        _isImportant = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Mark as High Priority',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _isImportant
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _isImportant
                                        ? myColors.forestGreen
                                        : Colors.black87,
                                  ),
                                ),
                                if (_isImportant) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.priority_high,
                                    color: myColors.forestGreen,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
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
                  onPressed: _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Create Task'),
                ),
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 400.ms, delay: 900.ms),
    );
  }
}
