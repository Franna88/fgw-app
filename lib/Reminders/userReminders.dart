import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Reminders/pages/addReminder.dart';
import 'package:farming_gods_way/Reminders/ui/reminderItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class UserReminders extends StatefulWidget {
  const UserReminders({super.key});

  @override
  State<UserReminders> createState() => _UserRemindersState();
}

class _UserRemindersState extends State<UserReminders> {
  bool _isLoading = true;
  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('reminders')
          .orderBy('date')
          .get();

      setState(() {
        reminders = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'field': data['field'] ?? 'Unknown Field',
            'portion': data['portion'] ?? 'Unknown Portion',
            'date': (data['date'] as Timestamp).toDate(),
            'reminder': data['reminder'] ?? '',
            'isCompleted': data['isCompleted'] ?? false,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reminders: $e');
      setState(() {
        reminders = [];
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading reminders: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateReminderStatus(
      String reminderId, bool isCompleted) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('reminders')
          .doc(reminderId)
          .update({'isCompleted': isCompleted});

      // Update local state
      setState(() {
        final index = reminders.indexWhere((r) => r['id'] == reminderId);
        if (index != -1) {
          reminders[index]['isCompleted'] = isCompleted;
        }
      });
    } catch (e) {
      print('Error updating reminder status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating reminder: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
                header: 'My Reminders',
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: CommonButton(
                  buttonColor: myColors.yellow,
                  textColor: myColors.black,
                  customWidth: double.infinity,
                  customHeight: 50,
                  buttonText: 'Add Reminder',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddReminder(),
                      ),
                    );
                    // Reload reminders after returning from add screen
                    _loadReminders();
                  },
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : reminders.isEmpty
                        ? _buildEmptyState(myColors)
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            itemCount: reminders.length,
                            itemBuilder: (context, index) {
                              final reminder = reminders[index];
                              final date = reminder['date'] as DateTime;
                              return ReminderItem(
                                field: reminder['field'] as String,
                                portion: reminder['portion'] as String,
                                reminder: reminder['reminder'] as String,
                                date: date,
                                checkBoxValue: reminder['isCompleted'] as bool,
                                onChanged: (value) {
                                  _updateReminderStatus(
                                      reminder['id'], value ?? false);
                                },
                              ).animate().fadeIn(
                                    duration: 300.ms,
                                    delay: Duration(milliseconds: 50 * index),
                                  );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(MyColors myColors) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(20),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.calendarCheck,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No Reminders Yet',
              style: GoogleFonts.robotoSlab(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the "Add Reminder" button to create your first reminder',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
    );
  }
}
