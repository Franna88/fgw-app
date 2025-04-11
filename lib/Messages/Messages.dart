import 'package:farming_gods_way/Messages/ui/contactDisplay.dart';
import 'package:flutter/material.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';

// Replace with your color definitions
class MyTabColors {
  final Color forestGreen = Color(0xFF00764E);
  final Color lightCream = Color(0xFFFAF9EB);
}

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTabColors().forestGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FgwTopBar(),

              SizedBox(height: 15),

              CornerHeaderContainer(
                header: 'Messages',
                hasBackArrow: false,
              ),

              SizedBox(height: 15),

              // Tab Bar
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTabIndex = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 0
                              ? MyTabColors().lightCream
                              : Colors.black87,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          'Messages',
                          style: TextStyle(
                            color: selectedTabIndex == 0
                                ? Colors.black
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTabIndex = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 1
                              ? MyTabColors().lightCream
                              : Colors.black87,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          'Contacts',
                          style: TextStyle(
                            color: selectedTabIndex == 1
                                ? Colors.black
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MyTabColors().lightCream,
                  ),
                  child: selectedTabIndex == 0
                      ? Center(child: Text('Message content here'))
                      : Center(
                          child: ContactDisplay(
                              image: 'images/userImage.png',
                              userName: 'Eric Bester')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
