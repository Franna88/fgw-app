import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmIrrigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:farming_gods_way/services/user_provider.dart';
import 'package:farming_gods_way/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../Constants/myutility.dart';

class FarmMap extends StatefulWidget {
  const FarmMap({super.key});

  @override
  State<FarmMap> createState() => _FarmMapState();
}

class _FarmMapState extends State<FarmMap> {
  double? latitude = -25.7461;
  double? longitude = 28.1881;
  bool isLoading = false;
  GoogleMapController? _mapController;
  Marker? _farmMarker;
  CameraPosition get _initialCameraPosition =>
      CameraPosition(target: LatLng(latitude!, longitude!), zoom: 14);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      _farmMarker = Marker(
        markerId: MarkerId('farm_marker'),
        position: position,
      );
    });
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _confirmLocation() async {
    if (latitude != null && longitude != null) {
      try {
        setState(() {
          isLoading = true;
        });

        // Save coordinates to user provider for later use
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final farmData = userProvider.registrationData;

        // Update the registration data with coordinates
        farmData['farmLocation'] = {
          'latitude': latitude,
          'longitude': longitude,
        };

        userProvider.storeRegistrationData(farmData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location saved: ($latitude, $longitude)'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        // Navigate to the next page
        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FarmIrrigation()),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a location on the map'),
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
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
                              "Step 2 of 2",
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ),
                const SizedBox(height: 10),
                // Coordinates display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Coordinates: ${latitude?.toStringAsFixed(6)}, ${longitude?.toStringAsFixed(6)}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Google Map
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GoogleMap(
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: _onMapCreated,
                          markers:
                              _farmMarker != null
                                  ? {_farmMarker!}
                                  : {
                                    Marker(
                                      markerId: const MarkerId('farm_marker'),
                                      position: LatLng(latitude!, longitude!),
                                    ),
                                  },
                          onTap: _onMapTap,
                          zoomControlsEnabled:
                              false, // We'll add custom controls
                          myLocationButtonEnabled: false,
                        ),
                      ),
                      // Zoom controls
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              heroTag: 'zoomIn',
                              mini: true,
                              backgroundColor: Colors.white,
                              onPressed: _zoomIn,
                              child: const Icon(Icons.add, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'zoomOut',
                              mini: true,
                              backgroundColor: Colors.white,
                              onPressed: _zoomOut,
                              child: const Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
                  child: Column(
                    children: [
                      isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : CommonButton(
                            customWidth: 200,
                            buttonText: 'Confirm Location',
                            onTap: _confirmLocation,
                          ),
                      const SizedBox(height: 15),
                      Text(
                        "Next: Farm irrigation details",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
