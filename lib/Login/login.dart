import 'dart:math';
import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/userPickPage.dart';
import 'package:farming_gods_way/Login/loginDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // List of Bible verses
  final List<String> _dummyTextList = [
    'May God give you of heaven\'s dew and of earth\'s richness - an abundance of grain and new wine. - Genesis 27:28',
    'The Lord will send a blessing on your barns and on everything you put your hand to. - Deuteronomy 28:8',
    'I alone know the plans I have for you, plans to bring you prosperity and not disaster. - Jeremiah 29:11',
    'Jesus said to them, "The times and occasions are set by my Father\'s own authority." - Acts 1:7',
    'Be sure you know the conditions of your flocks, give careful attention to your herds. - Proverbs 27:23-24',
    'Plant your seed in the morning and keep busy all afternoon. - Ecclesiastes 11:6',
    'Those too lazy to plow in the right season will have no food at the harvest. - Proverbs 20:4',
    'Good planning and hard work lead to prosperity, but hasty shortcuts lead to poverty. - Proverbs 21:5',
    'The farmer knows just what to do, for God has given him understanding. - Isaiah 28:26',
    'He will also send you rain for the seed you sow in the ground. - Isaiah 30:23',
    'As long as the earth endures, seedtime and harvest, cold and heat, summer and winter, day and night will never cease. - Genesis 8:22',
    'The one who plants and the one who waters work together with the same purpose. - 1 Corinthians 3:8',
    'When you have eaten and are satisfied, praise the Lord your God for the good land. - Deuteronomy 8:10',
    'Then we your people, the sheep of your pasture, will thank you forever and ever. - Psalm 79:13',
  ];

  // Get random text from the list
  String _getRandomText() {
    final random = Random();
    return _dummyTextList[random.nextInt(_dummyTextList.length)];
  }

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
          
          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App title section
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        "Farming God's Way",
                        style: GoogleFonts.robotoSlab(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
                      
                      const SizedBox(height: 10),
                      
                      Text(
                        "Sustainable farming through faithful stewardship",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                
                // Verse card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: MyColors().forestGreen.withOpacity(0.6),
                          size: 24,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getRandomText(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 300.ms).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                  ),
                ),
                
                // Buttons container at bottom
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonButton(
                        customWidth: double.infinity,
                        buttonText: 'Login',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginDetails(),
                            ),
                          );
                        },
                      ).animate().fadeIn(duration: 700.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 16),
                      
                      CommonButton(
                        customWidth: double.infinity,
                        buttonText: 'Sign Up',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserPickPage(),
                            ),
                          );
                        },
                      ).animate().fadeIn(duration: 700.ms, delay: 600.ms).slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
