import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:flutter/material.dart';

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
                child: Column(
                  children: [
                    CornerHeaderContainer(
                      header: 'Reminders',
                      hasBackArrow: true,
                    ),
                    const SizedBox(height: 15),
                    LabeledDropdown(
                      label: 'Field',
                      hintText: '',
                      items: [
                        'Field A',
                        'Field B',
                        'Field C',
                        'Field D',
                        'Field E'
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedField = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    LabeledDropdown(
                      label: 'Portion',
                      hintText: '',
                      items: ['Portion A', 'Portion B', 'Portion C'],
                      onChanged: (value) {
                        setState(() {
                          selectedPortion = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    LabeledDatePicker(
                      label: 'Reminder Date',
                      hintText: '',
                      controller: dateController,
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      lines: 5,
                      label: 'Reminder',
                      hintText: '',
                      controller: reminderController,
                    ),
                    const Spacer(),
                    CommonButton(
                      customWidth: MyUtility(context).width * 0.60,
                      buttonText: 'Save',
                      onTap: () {
                        if (selectedField == null ||
                            selectedPortion == null ||
                            dateController.text.isEmpty ||
                            reminderController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all fields")));
                          return;
                        }
                        Navigator.pop(context, {
                          'field': selectedField!,
                          'portion': selectedPortion!,
                          'date': dateController.text,
                          'reminder': reminderController.text,
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
