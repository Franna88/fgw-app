import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FgwLandingPage()
        //const Login(),

        );
  }
}
