import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Reminders/pages/addReminder.dart';
import 'package:farming_gods_way/Reminders/ui/reminderItem.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(
              height: MyUtility(context).height * 0.05,
            ),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    MyColors().forestGreen,
                    MyColors().lightGreen,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CornerHeaderContainer(
                        header: 'Reminders',
                        hasBackArrow: true,
                      ),
                      const SizedBox(height: 15),
                      CommonButton(
                        buttonColor: MyColors().yellow,
                        textColor: MyColors().black,
                        customWidth: MyUtility(context).width * 0.93,
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
                      const SizedBox(height: 15),
                      ...reminders.map((reminder) => ReminderItem(
                            field: reminder['field'],
                            portion: reminder['portion'],
                            reminder: reminder['reminder'],
                            date: reminder['date'],
                            checkBoxValue: false,
                            onChanged: (value) {},
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
