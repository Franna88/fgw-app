import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmSoil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/Buttons/counterWidget.dart';

import '../../Constants/myutility.dart';

class FarmToolsCount extends StatefulWidget {
  const FarmToolsCount({super.key});

  @override
  State<FarmToolsCount> createState() => _FarmToolsCountState();
}

class _FarmToolsCountState extends State<FarmToolsCount> {
  final Map<String, int> tools = {
    'Hoe': 0,
    'Trowel': 0,
    'Scythe': 0,
    'Sickle': 0,
    'Shovel': 0,
    'Tractor': 0,
  };

  final Map<String, bool> selectedTools = {
    'Hoe': true,
    'Trowel': false,
    'Scythe': true,
    'Sickle': false,
    'Shovel': true,
    'Tractor': true,
  };
  
  final Map<String, IconData> toolIcons = {
    'Hoe': FontAwesomeIcons.screwdriverWrench,
    'Trowel': FontAwesomeIcons.trowelBricks,
    'Scythe': FontAwesomeIcons.seedling,
    'Sickle': FontAwesomeIcons.hammer,
    'Shovel': FontAwesomeIcons.spoon,
    'Tractor': FontAwesomeIcons.tractor,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen.withOpacity(0.9),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'images/loginImg.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ).animate().fadeIn(duration: 300.ms),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Farm Tools",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 5 of 7",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ),
                
                const SizedBox(height: 10),
                
                // Form content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "Farm Tools Inventory",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                        
                        const SizedBox(height: 10),
                        
                        // Description
                        Text(
                          "Select the tools you have and specify their quantity",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                        
                        const SizedBox(height: 25),
                        
                        // Legend
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: MyColors().forestGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Select tool",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: MyColors().forestGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Set quantity",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                        
                        const SizedBox(height: 15),
                        const Divider(),
                        const SizedBox(height: 5),
                        
                        // Tools list
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: tools.keys.map((tool) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // Checkbox
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: selectedTools[tool],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                selectedTools[tool] = value!;
                                              });
                                            },
                                            activeColor: MyColors().forestGreen,
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        
                                        // Tool icon
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: MyColors().forestGreen.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            // Use generic icon if specific one not found
                                            toolIcons[tool] ?? FontAwesomeIcons.wrench,
                                            color: MyColors().forestGreen,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        
                                        // Tool name
                                        Text(
                                          tool,
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // Counter widget
                                    CounterWidget(
                                      count: tools[tool]!,
                                      onChanged: (value) {
                                        setState(() {
                                          tools[tool] = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(
                                duration: 400.ms,
                                delay: Duration(milliseconds: 200 + (tools.keys.toList().indexOf(tool) * 100)),
                              );
                            }).toList(),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Next button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              CommonButton(
                                customWidth: 200,
                                buttonText: 'Continue',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FarmSoil(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Next: Soil characteristics",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms, delay: 500.ms),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
