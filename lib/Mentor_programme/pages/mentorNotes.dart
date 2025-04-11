import 'package:farming_gods_way/Mentor_programme/pages/newMentorNote.dart';
import 'package:farming_gods_way/Mentor_programme/ui/mentorNoteItem.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class MentorNotes extends StatefulWidget {
  const MentorNotes({super.key});

  @override
  State<MentorNotes> createState() => _MentorNotesState();
}

class _MentorNotesState extends State<MentorNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColors().forestGreen, MyColors().lightGreen],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CornerHeaderContainer(
                        header: 'Mentor Notes', hasBackArrow: true),
                    const SizedBox(height: 15),
                    CommonButton(
                        buttonColor: MyColors().yellow,
                        textColor: MyColors().black,
                        customWidth: MyUtility(context).width * 0.93,
                        buttonText: 'Create New Note',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewMentorNote()),
                          );
                        }),
                    const SizedBox(height: 15),
                    Container(
                      height: MyUtility(context).height - 196,
                      width: MyUtility(context).width * 0.93,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      //List of Animals
                      child: MentorNoteItem(
                        date: '2024/06/12',
                        note:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, .',
                        refImage: 'images/potatoes.png',
                        header: 'header',
                      ),
                    ),
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
