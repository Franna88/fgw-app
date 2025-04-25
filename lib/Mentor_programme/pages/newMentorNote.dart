import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:farming_gods_way/Mentor_programme/pages/mentorNotes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final header = TextEditingController();
  final noteDate = TextEditingController();
  final note = TextEditingController();
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MyUtility(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MyColors().forestGreen, MyColors().lightGreen],
                stops: const [0.2, 0.9],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  CornerHeaderContainer(
                    header: 'Create Note',
                    hasBackArrow: true,
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Note Details",
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MyColors().forestGreen,
                              ),
                            ),
                            const SizedBox(height: 15),
                            LabeledTextField(
                              label: 'Header',
                              hintText: 'Enter note title',
                              controller: header,
                            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                            const SizedBox(height: 15),
                            LabeledDatePicker(
                              label: 'Note Date',
                              hintText: 'Select date',
                              controller: noteDate,
                            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                            const SizedBox(height: 15),
                            LabeledTextField(
                              label: 'Note',
                              hintText: 'Write your thoughts here...',
                              controller: note,
                              lines: 4,
                            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reference Photo",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors().forestGreen,
                                  ),
                                ),
                                Icon(
                                  FontAwesomeIcons.camera,
                                  size: 18,
                                  color: MyColors().forestGreen,
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isImageSelected = !isImageSelected;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Image picker will be implemented here'),
                                    backgroundColor: MyColors().forestGreen,
                                  ),
                                );
                              },
                              child: Container(
                                height: MyUtility(context).height * 0.18,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: MyColors().offWhite,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isImageSelected 
                                        ? MyColors().forestGreen 
                                        : Colors.grey.shade300,
                                    width: isImageSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: isImageSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          size: 50,
                                          color: MyColors().forestGreen,
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              size: 50,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Tap to select an image",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600,
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(height: 30),
                  CommonButton(
                    customWidth: MyUtility(context).width * 0.4,
                    buttonText: 'Save Note',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MentorNotes()),
                      );
                    },
                  ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
