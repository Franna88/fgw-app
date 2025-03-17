import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateDetails.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class TaskCreateFieldSelect extends StatefulWidget {
  const TaskCreateFieldSelect({super.key});

  @override
  State<TaskCreateFieldSelect> createState() => _TaskCreateFieldSelectState();
}

class _TaskCreateFieldSelectState extends State<TaskCreateFieldSelect> {
  @override
  Widget build(BuildContext context) {
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
                CornerHeaderContainer(
                  header: 'Add Tasks',
                  hasBackArrow: true,
                ),
                const Spacer(),
                LabeledDropdown(
                  label: 'Field',
                  hintText: '',
                  items: [],
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                LabeledDropdown(
                  label: 'Field Portion',
                  hintText: '',
                  items: [],
                  onChanged: (value) {},
                ),
                const Spacer(),
                CommonButton(
                    customWidth: 200,
                    buttonText: 'Next',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TaskCreateDetails()),
                      );
                    }),
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
