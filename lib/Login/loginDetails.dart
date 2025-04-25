import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myTextButton.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      // If validation passes, proceed with login logic
      print("Login Successful with Email: ${email.text}");
      
      // Navigate to landing page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FgwLandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen.withOpacity(0.9),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
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
              
              SafeArea(
                child: Column(
                  children: [
                    // Back button and header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ).animate().fadeIn(duration: 300.ms),
                          const SizedBox(width: 10),
                          Text(
                            "Login to your Account",
                            style: GoogleFonts.robotoSlab(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Main content area with white background
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
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
                            const SizedBox(height: 20),
                            
                            // Welcome message
                            Text(
                              "Welcome Back",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: MyColors().forestGreen,
                              ),
                            ).animate().fadeIn(duration: 600.ms),
                            
                            const SizedBox(height: 10),
                            
                            Text(
                              "Please enter your credentials to continue",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ).animate().fadeIn(duration: 700.ms),
                            
                            const SizedBox(height: 30),
                            
                            // Form
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Email field
                                  Text(
                                    "Email",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ).animate().fadeIn(duration: 800.ms),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      controller: email,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter your email',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                        prefixIcon: Icon(Icons.email_outlined, color: MyColors().forestGreen),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email cannot be empty';
                                        }
                                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                            .hasMatch(value)) {
                                          return 'Enter a valid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Password field
                                  Text(
                                    "Password",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ).animate().fadeIn(duration: 900.ms),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      controller: password,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter your password',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                        prefixIcon: Icon(Icons.lock_outline, color: MyColors().forestGreen),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password cannot be empty';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ).animate().fadeIn(duration: 900.ms).slideY(begin: 0.2, end: 0),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                            
                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Forgot password logic
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: MyColors().forestGreen,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(duration: 1000.ms),
                            
                            const Spacer(),
                            
                            // Login button
                            Center(
                              child: CommonButton(
                                customWidth: 160,
                                buttonText: 'Login',
                                onTap: _validateAndLogin,
                              ),
                            ).animate().fadeIn(duration: 1100.ms).scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
