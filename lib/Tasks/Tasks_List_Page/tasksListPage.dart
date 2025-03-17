import 'package:farming_gods_way/Tasks/Create_Task/taskCreateDetails.dart';
import 'package:farming_gods_way/Tasks/Tasks_List_Page/ui/taskItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
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
                  colors: [MyColors().forestGreen, MyColors().lightGreen]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  CornerHeaderContainer(
                    header: 'Tasks',
                    hasBackArrow: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MyUtility(context).width - 30,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: MyColors().offWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Field A',
                            style: GoogleFonts.roboto(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Portion B',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
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
                            builder: (context) => const TaskCreateDetails()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 60,
                    width: MyUtility(context).width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MyColors().black),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MyUtility(context).width * 0.90 - 80,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              minHeight: 12,
                              backgroundColor:
                                  const Color.fromARGB(255, 221, 221, 221),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(255, 95, 199, 98),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Text(
                            '1/2',
                            style: GoogleFonts.roboto(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MyUtility(context).width - 30,
                    height: MyUtility(context).height * 0.95 - 318,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors().offWhite),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TaskItem(
                            hasImage: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TaskItem(
                            hasImage: false,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
