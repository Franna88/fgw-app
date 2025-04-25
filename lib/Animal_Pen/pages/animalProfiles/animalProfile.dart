import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AnimalProfile extends StatefulWidget {
  const AnimalProfile({super.key});

  @override
  State<AnimalProfile> createState() => _AnimalProfileState();
}

class _AnimalProfileState extends State<AnimalProfile> with SingleTickerProviderStateMixin {
  bool _isPregnancyTracking = true;
  late TabController _tabController;
  
  // Sample data - would come from a database in a real app
  final Map<String, dynamic> _animalData = {
    'name': 'Samy',
    'gender': 'female',
    'age': '2 years',
    'type': 'Sheep',
    'weight': '65 kg',
    'height': '110 cm',
    'birthDate': '15 May 2022',
    'pregnancyStart': '02 Dec 2024',
    'pregnancyEnd': '02 May 2025',
    'lastCheckup': '25 Jul 2024',
    'nextCheckup': '25 Oct 2024',
    'health': 'Good',
    'vaccinations': [
      {'name': 'Rabies', 'date': '15 Jan 2024'},
      {'name': 'Tetanus', 'date': '20 Mar 2024'},
    ],
  };
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          height: MyUtility(context).height,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: 'Animal Profile', 
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              const SizedBox(height: 15),
              
              // Animal header and image
              _buildAnimalHeader(myColors, screenWidth),
              
              const SizedBox(height: 20),
              
              // Tabs and content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      
                      // Tab bar
                      TabBar(
                        controller: _tabController,
                        labelColor: myColors.forestGreen,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: myColors.forestGreen,
                        indicatorWeight: 3,
                        labelStyle: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'DETAILS'),
                          Tab(text: 'HEALTH'),
                          Tab(text: 'RECORDS'),
                        ],
                      ),
                      
                      // Tab content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildDetailsTab(myColors),
                            _buildHealthTab(myColors),
                            _buildRecordsTab(myColors),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.yellow,
        foregroundColor: myColors.black,
        child: const Icon(Icons.edit),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Edit feature coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildAnimalHeader(MyColors myColors, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 220,
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'images/livestock.png',
                height: 220,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
            ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            
            // Bottom info bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _animalData['name'],
                      style: GoogleFonts.robotoSlab(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _animalData['age'],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      _animalData['gender'] == 'male' ? Icons.male : Icons.female,
                      color: _animalData['gender'] == 'male'
                          ? Colors.lightBlueAccent
                          : Colors.pinkAccent,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
            
            // Animal type pill
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: myColors.forestGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _animalData['type'],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
  
  Widget _buildDetailsTab(MyColors myColors) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoSection(
          'Basic Information',
          [
            _buildInfoRow('Type', _animalData['type'], Icons.category),
            _buildInfoRow('Age', _animalData['age'], Icons.calendar_today),
            _buildInfoRow('Gender', _animalData['gender'].toString().capitalize(), 
              _animalData['gender'] == 'male' ? Icons.male : Icons.female,
              iconColor: _animalData['gender'] == 'male' ? Colors.lightBlueAccent : Colors.pinkAccent),
            _buildInfoRow('Weight', _animalData['weight'], Icons.monitor_weight),
            _buildInfoRow('Height', _animalData['height'], Icons.height),
            _buildInfoRow('Birth Date', _animalData['birthDate'], Icons.cake),
          ],
          myColors,
        ),
        
        const SizedBox(height: 20),
        
        _buildInfoSection(
          'Health Status',
          [
            _buildInfoRow('Health', _animalData['health'], Icons.health_and_safety, 
              valueColor: _animalData['health'] == 'Good' ? Colors.green : Colors.red),
            _buildInfoRow('Last Checkup', _animalData['lastCheckup'], Icons.event_available),
            _buildInfoRow('Next Checkup', _animalData['nextCheckup'], Icons.event),
          ],
          myColors,
        ),
        
        const SizedBox(height: 20),
        
        if (_animalData['gender'] == 'female')
          _buildPregnancySection(myColors),
      ],
    );
  }
  
  Widget _buildPregnancySection(MyColors myColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pregnancy Tracking',
              style: GoogleFonts.robotoSlab(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            Switch(
              value: _isPregnancyTracking,
              onChanged: (value) {
                setState(() {
                  _isPregnancyTracking = value;
                });
              },
              activeColor: myColors.forestGreen,
            ),
          ],
        ),
        
        if (_isPregnancyTracking) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Pregnancy Start', _animalData['pregnancyStart'], Icons.play_arrow),
                const SizedBox(height: 12),
                _buildInfoRow('Expected End', _animalData['pregnancyEnd'], Icons.flag),
                const SizedBox(height: 16),
                const LinearProgressIndicator(
                  value: 0.3, // Would calculate based on dates
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  '30% Complete (120 days remaining)',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ],
    );
  }
  
  Widget _buildHealthTab(MyColors myColors) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoSection(
          'Vaccinations',
          [
            for (var vaccination in _animalData['vaccinations'])
              _buildInfoRow(
                vaccination['name'], 
                vaccination['date'], 
                Icons.medical_services,
              ),
          ],
          myColors,
        ),
        
        const SizedBox(height: 20),
        
        CommonButton(
          customWidth: double.infinity,
          buttonText: 'Add Health Record',
          buttonColor: myColors.forestGreen,
          textColor: Colors.white,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This feature is coming soon'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // Placeholder for health records that would be filled
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(
                Icons.healing,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Health Records',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Detailed health records will appear here',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecordsTab(MyColors myColors) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Placeholder for production records
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(
                Icons.bar_chart,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Production Records',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track production metrics for this animal',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        CommonButton(
          customWidth: double.infinity,
          buttonText: 'Add Production Record',
          buttonColor: myColors.forestGreen,
          textColor: Colors.white,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This feature is coming soon'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // Placeholder for history logs
        _buildInfoSection(
          'History',
          [
            _buildInfoRow('Added to farm', '01 Jun 2022', Icons.history),
            _buildInfoRow('Last weight recorded', '15 Jul 2024', Icons.monitor_weight),
            _buildInfoRow('Last pregnancy', 'None', Icons.child_care),
          ],
          myColors,
        ),
      ],
    );
  }
  
  Widget _buildInfoSection(String title, List<Widget> rows, MyColors myColors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: myColors.forestGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
  
  Widget _buildInfoRow(String label, String value, IconData icon, {Color? iconColor, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
