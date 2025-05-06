import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myTextButton.dart';
import 'package:farming_gods_way/Sign_Ups/Worker_Registration/workerSignUpStepTwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../Constants/colors.dart';
import '../../services/user_provider.dart';

class WorkerSignUpStepOne extends StatefulWidget {
  const WorkerSignUpStepOne({super.key});

  @override
  State<WorkerSignUpStepOne> createState() => _WorkerSignUpStepOneState();
}

class _WorkerSignUpStepOneState extends State<WorkerSignUpStepOne> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController idPassportController = TextEditingController();

  bool hasUploadedDocument = false;
  File? _documentFile;
  bool _isLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  String? _validateIdPassport(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID/Passport number is required';
    }
    if (value.length < 6) {
      return 'ID/Passport number is too short';
    }
    return null;
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      // Store the worker data in UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // First clear any existing registration data
      userProvider.clearRegistrationData();

      // Then store the new data
      userProvider.storeRegistrationData({
        'email': emailController.text.trim(),
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'idPassportNumber': idPassportController.text.trim(),
        'userType': 'worker', // Mark this as a worker registration
        'hasUploadedDocument': hasUploadedDocument,
        // Don't store the document file here - it will be uploaded later
      });

      // Proceed to next step if validation is successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WorkerSignUpStepTwo(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _uploadDocument() async {
    try {
      // Use image picker to select document
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _documentFile = File(image.path);
          hasUploadedDocument = true;
        });

        // Store file path in UserProvider for later use
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.storeRegistrationData({
          'documentFilePath': image.path,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document selected successfully'),
            backgroundColor: MyColors().forestGreen,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting document: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    _isLoading = userProvider.isLoading;

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              "Worker Information",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 1 of 2",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms),
                ),

                const SizedBox(height: 10),

                // Form content
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),

                            // Email field
                            _buildFormField(
                              label: 'Email Address',
                              controller: emailController,
                              hintText: 'Enter your email address',
                              icon: Icons.email_outlined,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 20),

                            // First name field
                            _buildFormField(
                              label: 'First Name',
                              controller: firstNameController,
                              hintText: 'Enter your first name',
                              icon: Icons.person_outline,
                              validator: (value) =>
                                  _validateNotEmpty(value, 'First Name'),
                            )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 100.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 20),

                            // Last name field
                            _buildFormField(
                              label: 'Last Name',
                              controller: lastNameController,
                              hintText: 'Enter your last name',
                              icon: Icons.person_outline,
                              validator: (value) =>
                                  _validateNotEmpty(value, 'Last Name'),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 200.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 20),

                            // ID/Passport field
                            _buildFormField(
                              label: 'ID/Passport Number',
                              controller: idPassportController,
                              hintText: 'Enter your ID or passport number',
                              icon: Icons.badge_outlined,
                              validator: _validateIdPassport,
                            )
                                .animate()
                                .fadeIn(duration: 700.ms, delay: 300.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 25),

                            // Document upload section
                            InkWell(
                              onTap: _uploadDocument,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color:
                                      MyColors().forestGreen.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        MyColors().forestGreen.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: MyColors()
                                            .forestGreen
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        hasUploadedDocument
                                            ? Icons.check_circle_outline
                                            : Icons.cloud_upload_outlined,
                                        color: MyColors().forestGreen,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hasUploadedDocument
                                                ? "Document Uploaded"
                                                : "Upload ID/Passport Document",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            hasUploadedDocument
                                                ? "Tap to change document"
                                                : "Please provide a photo of your ID/Passport",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(duration: 800.ms, delay: 400.ms),

                            const SizedBox(height: 40),

                            // Next button
                            Center(
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: MyColors().forestGreen,
                                    )
                                  : CommonButton(
                                      customWidth: 160,
                                      buttonText: 'Next',
                                      onTap: _onNextPressed,
                                    ),
                            ).animate().fadeIn(duration: 900.ms, delay: 500.ms),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.05, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              prefixIcon: Icon(icon, color: MyColors().forestGreen),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
