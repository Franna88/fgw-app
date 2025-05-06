import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:farming_gods_way/services/user_provider.dart';
import 'package:farming_gods_way/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Constants/colors.dart';

class FarmLocation extends StatefulWidget {
  const FarmLocation({super.key});

  @override
  State<FarmLocation> createState() => _FarmLocationState();
}

class _FarmLocationState extends State<FarmLocation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController farmName = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController address = TextEditingController();
  bool isLoading = false;

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save the farm location data
      final farmData = {
        'farmName': farmName.text,
        'location': location.text,
        'address': address.text,
        'registrationStep': 'location',
      };

      // Store the farm data in the UserProvider
      Provider.of<UserProvider>(context, listen: false)
          .storeRegistrationData(farmData);

      // Create or update the farm document in Firestore
      _saveFarmData(farmData);

      // Proceed to the next step
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmMap(),
        ),
      );
    } else {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _saveFarmData(Map<String, dynamic> farmData) async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseService.currentUser;

      if (user != null) {
        // Create a unique ID for the farm
        String farmId = farmName.text.toLowerCase().replaceAll(' ', '_') +
            '_${DateTime.now().millisecondsSinceEpoch}';

        // Store the farm ID in the UserProvider
        Provider.of<UserProvider>(context, listen: false)
            .storeRegistrationData({'farmId': farmId});

        // Save to Firestore
        await FirebaseService.firestore.collection('farms').doc(farmId).set({
          ...farmData,
          'farmId': farmId,
          'ownerId': user.uid,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        // Update the user's farms array
        await FirebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .update({
          'farms': FieldValue.arrayUnion([farmId])
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving farm data: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                              "Farm Registration",
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
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
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
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),

                                  // Farm Name field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Farm Name",
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: farmName,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter farm name',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Icon(
                                                FontAwesomeIcons.leaf,
                                                color: MyColors().forestGreen),
                                          ),
                                          validator: _validateField,
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms)
                                      .slideY(begin: 0.1, end: 0),

                                  const SizedBox(height: 30),

                                  // Farm Location field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Farm Location",
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: location,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter farm location',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Icon(
                                                FontAwesomeIcons.locationDot,
                                                color: MyColors().forestGreen),
                                          ),
                                          validator: _validateField,
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms)
                                      .slideY(begin: 0.1, end: 0),

                                  const SizedBox(height: 30),

                                  // Farm Address field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Farm Address",
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: TextFormField(
                                          controller: address,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter detailed farm address',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 16),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, top: 15),
                                              child: Icon(FontAwesomeIcons.home,
                                                  color:
                                                      MyColors().forestGreen),
                                            ),
                                            alignLabelWithHint: true,
                                          ),
                                          validator: _validateField,
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 100.ms)
                                      .slideY(begin: 0.1, end: 0),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Next button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              isLoading
                                  ? CircularProgressIndicator(
                                      color: MyColors().forestGreen)
                                  : CommonButton(
                                      customWidth: 200,
                                      buttonText: 'Proceed to Map',
                                      onTap: _submitForm,
                                    ),
                              const SizedBox(height: 15),
                              Text(
                                "Next: Pin your farm on the map",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
                      ],
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
}
