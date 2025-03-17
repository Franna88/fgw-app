import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Tasks/Task_Board/ui/fieldTaskBoardItem.dart';
import 'package:farming_gods_way/Tasks/Tasks_List_Page/tasksListPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldTaskBoard extends StatefulWidget {
  const FieldTaskBoard({super.key});

  @override
  State<FieldTaskBoard> createState() => _FieldTaskBoardState();
}

class _FieldTaskBoardState extends State<FieldTaskBoard> {
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
                              value: 0.4,
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
                            '2/6',
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
                    height: MyUtility(context).height * 0.95 - 265,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors().offWhite),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            FieldTaskBoardItem(
                              row: 'Row 1',
                              tasksComplete: '3/3',
                              faze: 'Grow out',
                              progressValue: 1,
                              isImportant: false,
                              onTap: () {},
                            ),
                            FieldTaskBoardItem(
                              row: 'Row 2',
                              tasksComplete: '3/3',
                              faze: 'Grow out',
                              progressValue: 1,
                              isImportant: false,
                              onTap: () {},
                            ),
                            FieldTaskBoardItem(
                              row: 'Row 3',
                              tasksComplete: '1/2',
                              faze: 'Preperation',
                              progressValue: 0.5,
                              isImportant: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TasksListPage()),
                                );
                              },
                            ),
                            FieldTaskBoardItem(
                              row: 'Row 4',
                              tasksComplete: '2/6',
                              faze: 'Preperation',
                              progressValue: 0.4,
                              isImportant: false,
                              onTap: () {},
                            ),
                            FieldTaskBoardItem(
                              row: 'Row 5',
                              tasksComplete: '0/5',
                              faze: 'Preperation',
                              progressValue: 0,
                              isImportant: false,
                              onTap: () {},
                            ),
                            FieldTaskBoardItem(
                              row: 'Row 6',
                              tasksComplete: '0/6',
                              faze: 'Preperation',
                              progressValue: 0,
                              isImportant: false,
                              onTap: () {},
                            ),
                          ],
                        ),
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
