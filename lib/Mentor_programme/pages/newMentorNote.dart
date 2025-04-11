import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:farming_gods_way/Mentor_programme/pages/mentorNotes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/Input_Fields/labeledTextField.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class NewMentorNote extends StatefulWidget {
  const NewMentorNote({super.key});

  @override
  State<NewMentorNote> createState() => _NewMentorNoteState();
}

class _NewMentorNoteState extends State<NewMentorNote> {
  @override
  Widget build(BuildContext context) {
    final header = TextEditingController();
    final noteDate = TextEditingController();
    final note = TextEditingController();
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
                    colors: [MyColors().forestGreen, MyColors().lightGreen]),
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
                    header: 'Create Note',
                    hasBackArrow: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Header',
                    hintText: '',
                    controller: header,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledDatePicker(
                    label: 'Note Date',
                    hintText: '',
                    controller: noteDate,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LabeledTextField(
                    label: 'Note',
                    hintText: '',
                    controller: note,
                    lines: 4,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MyUtility(context).width * 0.90,
                    child: Text(
                      'Add a referance photo',
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
                    height: 25,
                  ),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.35,
                    buttonText: 'Save',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MentorNotes()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
