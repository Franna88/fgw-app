import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  String? selectedField;
  String? selectedPortion;
  bool _isLoading = false;
  List<String> _fields = [];
  List<String> _portions = [];

  bool get _isFormValid =>
      selectedField != null &&
      selectedPortion != null &&
      dateController.text.isNotEmpty &&
      reminderController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadFields();

    // Set a listener for the dateController to debug
    dateController.addListener(() {
      print('Date controller text changed: ${dateController.text}');
    });
  }

  @override
  void dispose() {
    // Clean up controllers
    dateController.dispose();
    reminderController.dispose();
    super.dispose();
  }

  Future<void> _loadFields() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final fieldsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .get();

      setState(() {
        _fields = fieldsSnapshot.docs.map((doc) {
          final data = doc.data();
          return data['name'] as String? ?? 'Unnamed Field';
        }).toList();
      });
    } catch (e) {
      print('Error loading fields: $e');
      setState(() {
        _fields = ['Field A', 'Field B', 'Field C']; // Fallback data
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading fields: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadPortions(String fieldName) async {
    setState(() {
      _portions = []; // Clear portions immediately when loading new ones
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // First get the field ID for the selected field name
      final fieldQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .where('name', isEqualTo: fieldName)
          .limit(1)
          .get();

      if (fieldQuery.docs.isEmpty) {
        throw 'Field not found';
      }

      final fieldId = fieldQuery.docs.first.id;

      // Now get portions for this field ID
      final portionsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(fieldId)
          .collection('portions')
          .get();

      if (portionsSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No portions found for this field'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _portions = portionsSnapshot.docs.map((doc) {
          final data = doc.data();
          return data['name'] as String? ?? 'Unnamed Portion';
        }).toList();
      });
    } catch (e) {
      print('Error loading portions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading portions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveReminder() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill all fields",
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          backgroundColor: MyColors().forestGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Validate date format first
      final dateParts = dateController.text.split('/');
      if (dateParts.length != 3) {
        throw 'Invalid date format. Please use DD/MM/YYYY format';
      }

      // Parse date parts with validation
      final day = int.tryParse(dateParts[0]);
      final month = int.tryParse(dateParts[1]);
      final year = int.tryParse(dateParts[2]);

      if (day == null || month == null || year == null) {
        throw 'Invalid date numbers. Please use valid numbers in DD/MM/YYYY format';
      }

      final reminderDate = DateTime(year, month, day);

      // Get field and portion IDs
      final fieldQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .where('name', isEqualTo: selectedField)
          .limit(1)
          .get();

      if (fieldQuery.docs.isEmpty) {
        throw 'Field not found';
      }

      final fieldId = fieldQuery.docs.first.id;

      // Find the portion ID
      final portionQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(fieldId)
          .collection('portions')
          .where('name', isEqualTo: selectedPortion)
          .limit(1)
          .get();

      if (portionQuery.docs.isEmpty) {
        throw 'Portion not found';
      }

      final portionId = portionQuery.docs.first.id;

      // Create a reference for the new reminder in the user's reminders subcollection
      final reminderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('reminders')
          .doc();

      // Create the reminder data
      final reminder = {
        'id': reminderRef.id,
        'fieldId': fieldId,
        'portionId': portionId,
        'field': selectedField,
        'portion': selectedPortion,
        'date': Timestamp.fromDate(reminderDate),
        'reminder': reminderController.text,
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': currentUser.uid, // Add user ID for additional security
      };

      // Save to Firestore
      await reminderRef.set(reminder);

      // Return the reminder data
      Navigator.pop(context, reminder);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error saving reminder: $e",
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      print('Selected date: $formattedDate');

      setState(() {
        dateController.text = formattedDate;
      });
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
                header: 'Add Reminder',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _buildReminderCard(myColors, screenWidth),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : CommonButton(
                        customWidth: screenWidth * 0.6,
                        customHeight: 50,
                        buttonText: 'Save Reminder',
                        buttonColor: myColors.yellow,
                        textColor: myColors.black,
                        onTap: _saveReminder,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard(MyColors myColors, double screenWidth) {
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
                FaIcon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: myColors.forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Reminder Details',
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
            LabeledDropdown(
              label: 'Field',
              hintText: 'Select a field',
              items: _fields,
              onChanged: (value) {
                setState(() {
                  selectedField = value;
                  selectedPortion = null; // Reset portion when field changes
                });
                if (value != null) {
                  _loadPortions(value);
                }
              },
            ),
            const SizedBox(height: 20),
            LabeledDropdown(
              label: 'Portion',
              hintText: 'Select a portion',
              items: _portions,
              onChanged: (value) {
                setState(() {
                  selectedPortion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder Date',
                    style: GoogleFonts.roboto(
                      letterSpacing: 1.1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectCustomDate(context),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateController.text.isEmpty
                                ? 'Select a date'
                                : dateController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: dateController.text.isEmpty
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LabeledTextField(
              lines: 5,
              label: 'Reminder',
              hintText: 'Enter reminder details',
              controller: reminderController,
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
                      'All fields are required. You\'ll be able to view this reminder in your reminders list.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: myColors.forestGreen,
                      ),
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
}
