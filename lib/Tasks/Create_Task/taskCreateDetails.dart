import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class TaskCreateDetails extends StatefulWidget {
  const TaskCreateDetails({super.key});

  @override
  State<TaskCreateDetails> createState() => _TaskCreateDetailsState();
}

class _TaskCreateDetailsState extends State<TaskCreateDetails> {
  @override
  Widget build(BuildContext context) {
    final task = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: Column(
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
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                CornerHeaderContainer(header: 'Add Tasks', hasBackArrow: true,),
                const SizedBox(
                  height: 15,
                ),
                LabeledTextField(
                  label: 'Task',
                  hintText: '',
                  controller: task,
                  lines: 5,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MyUtility(context).width * 0.90,
                  child: Text(
                    'Add Reference Image to Task (Optional)',
                    style: GoogleFonts.roboto(
                      letterSpacing: 1.1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: MyUtility(context).height * 0.25,
                  width: MyUtility(context).width * 0.90,
                  decoration: BoxDecoration(
                    color: MyColors().offWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 55,
                  width: MyUtility(context).width * 0.90,
                  decoration: BoxDecoration(
                    color: MyColors().offWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        activeColor: MyColors().black,
                      ),
                      Text(
                        'Mark this Task as important',
                        style: GoogleFonts.roboto(
                          letterSpacing: 1.1,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CommonButton(
                    customWidth: 200, buttonText: 'Create Task', onTap: () {}),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
