import 'package:farming_gods_way/CommonUi/Input_Fields/mySearchBarWidget.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Login/login.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:farming_gods_way/Sign_Ups/Worker_Registration/ui/farmerRequestItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../services/user_provider.dart';
import '../../services/firebase_service.dart';

class WorkerFarmerSearch extends StatefulWidget {
  const WorkerFarmerSearch({super.key});

  @override
  State<WorkerFarmerSearch> createState() => _WorkerFarmerSearchState();
}

class _WorkerFarmerSearchState extends State<WorkerFarmerSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> farmers = [];
  List<Map<String, dynamic>> filteredFarmers = [];
  bool _isLoading = true;
  String? _error;
  bool _isCompletingRegistration = false;
  String? _userId;
  Set<String> _requestedFarmerIds = {};

  @override
  void initState() {
    super.initState();
    _fetchFarmers();
  }

  Future<void> _fetchFarmers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get farmers from Firestore
      final QuerySnapshot querySnapshot =
          await FirebaseService.firestore.collection('farmers').get();

      // Convert to list of maps
      final List<Map<String, dynamic>> fetchedFarmers = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        fetchedFarmers.add({
          'id': doc.id,
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',
          'email': data['email'] ?? '',
          'number': data['phoneNumber'] ?? '',
          'image': data['profileImageUrl'] ?? 'images/userImage.png',
        });
      }

      setState(() {
        farmers = fetchedFarmers;
        filteredFarmers = List.from(farmers);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load farmers: $e';
      });
    }
  }

  void _filterFarmers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFarmers = List.from(farmers);
      } else {
        filteredFarmers = farmers
            .where((farmer) =>
                farmer['name'].toLowerCase().contains(query.toLowerCase()) ||
                farmer['email'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _sendRequestToFarmer(Map<String, dynamic> farmer) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final registrationData = userProvider.registrationData;

      // If this is the first time, create the worker account
      if (_userId == null) {
        // Create worker auth account
        final email = registrationData['email'] ?? '';
        // Generate a temporary password (can be changed later)
        final password =
            '${registrationData['firstName']}${DateTime.now().millisecondsSinceEpoch}'
                .substring(0, 10);

        // Create the user account
        UserCredential userCredential =
            await FirebaseService.createUserWithEmailAndPassword(
                email, password);

        _userId = userCredential.user?.uid;

        final firstName = registrationData['firstName'] ?? '';
        final lastName = registrationData['lastName'] ?? '';
        final fullName = '$firstName $lastName';

        // Update display name
        await userCredential.user?.updateDisplayName(fullName);

        // Upload ID/Passport document if provided
        String? documentUrl;
        if (registrationData['documentFilePath'] != null) {
          final documentFile = File(registrationData['documentFilePath']);
          documentUrl = await FirebaseService.uploadDocument(
              documentFile, _userId!, 'idDocument');
        }

        // Create worker document in Firestore
        await FirebaseService.firestore.collection('users').doc(_userId).set({
          ...registrationData,
          'uid': _userId,
          'displayName': fullName,
          'createdAt': FieldValue.serverTimestamp(),
          'idDocumentUrl': documentUrl,
          'userType': 'worker',
        });

        // Also create worker in workers collection
        await FirebaseService.createWorker(_userId!, {
          ...registrationData,
          'idDocumentUrl': documentUrl,
        });
      }

      // Create request in Firestore
      final requestData = {
        'workerId': _userId,
        'farmerId': farmer['id'],
        'workerName':
            '${registrationData['firstName']} ${registrationData['lastName']}',
        'farmerName': farmer['name'],
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseService.firestore
          .collection('worker_requests')
          .add(requestData);

      // Add this farmer to the set of requested farmers
      setState(() {
        _requestedFarmerIds.add(farmer['id']);
        _isLoading = false;
      });

      _showRequestSentDialog(context, farmer['name']);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending request: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _completeRegistration() async {
    try {
      setState(() {
        _isCompletingRegistration = true;
      });

      // Sign out the current user to return to login
      await FirebaseService.signOut();

      setState(() {
        _isCompletingRegistration = false;
      });

      // Clear registration data
      Provider.of<UserProvider>(context, listen: false).clearRegistrationData();

      // Navigate to login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _isCompletingRegistration = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing registration: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
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
                              "Search Farmer",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Find and connect with farmers",
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

                const SizedBox(height: 10),

                // Form content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Description text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Search for your farmer and request access to view the farm workboard',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 25),

                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterFarmers,
                            decoration: InputDecoration(
                              hintText: 'Search by name or email',
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: MyColors().forestGreen,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          filteredFarmers = List.from(farmers);
                                        });
                                      },
                                      color: Colors.grey[500],
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 100.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 25),

                        // Farmers list
                        Expanded(
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: MyColors().forestGreen,
                                  ),
                                )
                              : _error != null
                                  ? _buildErrorState()
                                  : filteredFarmers.isEmpty
                                      ? _buildEmptyState()
                                      : ListView.builder(
                                          itemCount: filteredFarmers.length,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final farmer =
                                                filteredFarmers[index];
                                            final bool alreadyRequested =
                                                _requestedFarmerIds
                                                    .contains(farmer['id']);

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: Colors.grey[200]!,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Row(
                                                  children: [
                                                    // Farmer image
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                          color: MyColors()
                                                              .forestGreen
                                                              .withOpacity(0.2),
                                                          width: 2,
                                                        ),
                                                        image: DecorationImage(
                                                          image: farmer['image']
                                                                  .startsWith(
                                                                      'http')
                                                              ? NetworkImage(
                                                                      farmer[
                                                                          'image'])
                                                                  as ImageProvider
                                                              : AssetImage(
                                                                  farmer[
                                                                      'image']),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),

                                                    // Farmer details
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            farmer['name'],
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .email_outlined,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                farmer['email'] ??
                                                                    'No email',
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .phone_outlined,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                farmer['number'] ??
                                                                    'No number',
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Request button
                                                    ElevatedButton(
                                                      onPressed: alreadyRequested
                                                          ? null
                                                          : () =>
                                                              _sendRequestToFarmer(
                                                                  farmer),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            alreadyRequested
                                                                ? Colors
                                                                    .grey[300]
                                                                : MyColors()
                                                                    .forestGreen,
                                                        foregroundColor:
                                                            alreadyRequested
                                                                ? Colors
                                                                    .grey[700]
                                                                : Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16,
                                                          vertical: 10,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        elevation: 0,
                                                      ),
                                                      child: Text(
                                                        alreadyRequested
                                                            ? 'Requested'
                                                            : 'Request',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ).animate().fadeIn(
                                                  duration: 400.ms,
                                                  delay: Duration(
                                                      milliseconds:
                                                          200 + (index * 100)),
                                                );
                                          },
                                        ),
                        ),

                        const SizedBox(height: 20),

                        // Done button
                        _isCompletingRegistration
                            ? CircularProgressIndicator(
                                color: MyColors().forestGreen,
                              )
                            : CommonButton(
                                customWidth: 200,
                                buttonText: 'Complete Registration',
                                onTap: _completeRegistration,
                              )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 300.ms),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 50,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No farmers found',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try a different search term or try again later',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.circleExclamation,
            size: 50,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          Text(
            'Error Loading Farmers',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _error ?? 'An unknown error occurred',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchFarmers,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors().forestGreen,
              foregroundColor: Colors.white,
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  void _showRequestSentDialog(BuildContext context, String farmerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: MyColors().forestGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: MyColors().forestGreen,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Request Sent!',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your request to connect with $farmerName has been sent. You\'ll be notified once they respond.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors().forestGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
