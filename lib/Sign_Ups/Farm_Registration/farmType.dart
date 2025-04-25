import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Sign_Ups/Farm_Registration/farmToolsCount.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';

import '../../Constants/myutility.dart';

class FarmType extends StatefulWidget {
  const FarmType({super.key});

  @override
  State<FarmType> createState() => _FarmTypeState();
}

class _FarmTypeState extends State<FarmType> {
  final _farmTypes = ['Crop Farm', 'Animal Farm', 'Mixed Farm', 'Orchard', 'Other'];
  final _productionTypes = ['Organic', 'Conventional', 'Integrated', 'Biodynamic', 'Permaculture'];
  final _rowOrientations = ['North-South', 'East-West', 'Diagonal', 'Circular', 'Mixed'];
  final _groundSlopes = ['Flat', 'Gentle', 'Moderate', 'Steep', 'Terraced'];
  
  String? _selectedFarmType;
  String? _selectedProductionType;
  String? _selectedRowOrientation;
  String? _selectedGroundSlope;

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
                              "Farm Registration",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Step 4 of 4",
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
                          flex: 3,
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
                              color: Colors.white.withOpacity(0.5),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Farm type title
                          Text(
                            'Farm Type Information',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                          
                          const SizedBox(height: 10),
                          
                          Text(
                            'Tell us about your farm characteristics',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                          
                          const SizedBox(height: 25),
                          
                          // Farm type dropdown
                          _buildDropdown(
                            'Type of Farm',
                            'Select farm type',
                            _farmTypes,
                            _selectedFarmType,
                            (value) => setState(() => _selectedFarmType = value),
                            200.ms,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Production type dropdown
                          _buildDropdown(
                            'Farm Production Type',
                            'Select production type',
                            _productionTypes,
                            _selectedProductionType,
                            (value) => setState(() => _selectedProductionType = value),
                            300.ms,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Row orientation dropdown
                          _buildDropdown(
                            'Orientation of Rows',
                            'Select row orientation',
                            _rowOrientations,
                            _selectedRowOrientation,
                            (value) => setState(() => _selectedRowOrientation = value),
                            400.ms,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Ground slope dropdown
                          _buildDropdown(
                            'General Ground Slope',
                            'Select ground slope',
                            _groundSlopes,
                            _selectedGroundSlope,
                            (value) => setState(() => _selectedGroundSlope = value),
                            500.ms,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Farm type icons
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[100]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Common Farm Types',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[800],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildFarmTypeIcon(FontAwesomeIcons.wheatAwn, 'Crop'),
                                    _buildFarmTypeIcon(FontAwesomeIcons.cow, 'Animal'),
                                    _buildFarmTypeIcon(FontAwesomeIcons.tree, 'Orchard'),
                                    _buildFarmTypeIcon(FontAwesomeIcons.seedling, 'Mixed'),
                                  ],
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                          
                          const SizedBox(height: 40),
                          
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
                                        builder: (context) => const FarmToolsCount(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Next: Farm tools inventory",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 700.ms),
                        ],
                      ),
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
  
  Widget _buildDropdown(
    String label,
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged,
    Duration delay,
  ) {
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  hint,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color: MyColors().forestGreen,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: delay);
  }
  
  Widget _buildFarmTypeIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 28,
              color: MyColors().forestGreen,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }
}
