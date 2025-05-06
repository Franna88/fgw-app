import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'services/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SharedPreferences
      .getInstance(); // Initialize SharedPreferences at app start
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();

    // Initialize Firebase Analytics
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
      analytics: analytics,
    );

    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Farming God\'s Way',
        navigatorObservers: [observer], // Add Firebase Analytics observer
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: myColors.forestGreen,
          colorScheme: ColorScheme.fromSeed(
            seedColor: myColors.forestGreen,
            primary: myColors.forestGreen,
            secondary: myColors.lightGreen,
            error: myColors.brightRed,
            background: myColors.offWhite,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: myColors.forestGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: myColors.forestGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: myColors.forestGreen, width: 2),
            ),
          ),
          textTheme: GoogleFonts.robotoSlabTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.forestGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: GoogleFonts.robotoSlab(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.isLoggedIn
                ? const FgwLandingPage()
                : const Login();
          },
        ),
      ),
    );
  }
}
