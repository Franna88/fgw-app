import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateFieldSelect.dart';
import 'package:farming_gods_way/Tasks/Task_Board/fieldTaskBoard.dart';
import 'package:farming_gods_way/Tasks/ui/taskFieldsDisplayItem.dart';
import 'package:flutter/material.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../Constants/myutility.dart';

class TasksHome extends StatefulWidget {
  const TasksHome({super.key});

  @override
  State<TasksHome> createState() => _TasksHomeState();
}

class _TasksHomeState extends State<TasksHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            FgwTopBar(),
            SizedBox(
              height: 15,
            ),
            CornerHeaderContainer(
              header: 'Tasks',
              hasBackArrow: false,
            ),
            SizedBox(
              height: 15,
            ),
            CommonButton(
              customHeight: 38,
              customWidth: MyUtility(context).width * 0.93,
              buttonText: 'Add Tasks',
              textColor: MyColors().black,
              buttonColor: MyColors().yellow,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TaskCreateFieldSelect()),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: MyUtility(context).height - 213,
              width: MyUtility(context).width * 0.93,
              decoration: BoxDecoration(
                color: MyColors().offWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TasksFieldsDisplayItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FieldTaskBoard()),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
