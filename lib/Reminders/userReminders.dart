import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Reminders/pages/addReminder.dart';
import 'package:farming_gods_way/Reminders/ui/reminderItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class UserReminders extends StatefulWidget {
  const UserReminders({super.key});

  @override
  State<UserReminders> createState() => _UserRemindersState();
}

class _UserRemindersState extends State<UserReminders> {
  List<Map<String, dynamic>> reminders = [];

  void _addReminder(Map<String, dynamic> reminder) {
    setState(() {
      reminders.add(reminder);
    });
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
                    final newReminder = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddReminder(),
                      ),
                    );
                    if (newReminder != null) {
                      _addReminder(newReminder);
                    }
                  },
                ),
              ),
              
              Expanded(
                child: reminders.isEmpty
                  ? _buildEmptyState(myColors)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        return ReminderItem(
                          field: reminders[index]['field'],
                          portion: reminders[index]['portion'],
                          reminder: reminders[index]['reminder'],
                          date: reminders[index]['date'],
                          checkBoxValue: false,
                          onChanged: (value) {
                            // Handle checkbox changes here
                            setState(() {
                              // Remove or mark as complete
                            });
                          },
                        ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 50 * index));
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
