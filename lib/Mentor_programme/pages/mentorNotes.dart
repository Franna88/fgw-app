import 'package:farming_gods_way/Mentor_programme/pages/newMentorNote.dart';
import 'package:farming_gods_way/Mentor_programme/ui/mentorNoteItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  // Sample data - in a real app, this would come from a database or service
  final List<Map<String, String>> _notes = [
    {
      'title': 'Crop Rotation Plan',
      'dateTime': '2024-06-12 14:30:00',
      'body': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, .'
    },
    {
      'title': 'Soil Health Assessment',
      'dateTime': '2024-06-10 09:15:00',
      'body': 'Checked soil pH levels in the north field. Results show slightly acidic conditions (pH 6.2). Recommended adding lime to bring pH closer to neutral.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
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
                  colors: [myColors.forestGreen, myColors.lightGreen],
                ),
                borderRadius: const BorderRadius.only(
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
                        buttonColor: myColors.yellow,
                        textColor: myColors.black,
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
                        color: myColors.offWhite,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: _notes.isEmpty 
                        ? Center(
                            child: Text(
                              'No notes yet. Create your first note!',
                              style: TextStyle(color: myColors.black),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: _notes.length,
                            itemBuilder: (context, index) {
                              return MentorNoteItem(
                                title: _notes[index]['title'] ?? '',
                                dateTime: _notes[index]['dateTime'] ?? '',
                                body: _notes[index]['body'] ?? '',
                                showActions: true,
                              ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms)
                                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
                            },
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
