import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FarmerDataBlock extends StatefulWidget {
  final String age;
  final String country;
  final String yearsExp;
  final String province;
  final String fgwExp;
  final String city;
  final String englishProf;
  
  const FarmerDataBlock({
    super.key,
    required this.age,
    required this.country,
    required this.yearsExp,
    required this.province,
    required this.fgwExp,
    required this.city,
    required this.englishProf,
  });

  @override
  State<FarmerDataBlock> createState() => _FarmerDataBlockState();
}

class _FarmerDataBlockState extends State<FarmerDataBlock> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Farmer Details',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: myColors.forestGreen,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: myColors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.yearsExp} years exp.',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // First row of info cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Age',
                    widget.age,
                    FontAwesomeIcons.userClock,
                    myColors,
                    delay: 100.ms,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    'Country',
                    widget.country,
                    FontAwesomeIcons.globe,
                    myColors,
                    delay: 150.ms,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Second row of info cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Province',
                    widget.province,
                    FontAwesomeIcons.locationDot,
                    myColors,
                    delay: 200.ms,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    'City',
                    widget.city,
                    FontAwesomeIcons.city,
                    myColors,
                    delay: 250.ms,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Third row of info cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'FGW Experience',
                    '${widget.fgwExp} years',
                    FontAwesomeIcons.seedling,
                    myColors,
                    delay: 300.ms,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    'English Proficiency',
                    _getProficiencyText(widget.englishProf),
                    FontAwesomeIcons.language,
                    myColors,
                    delay: 350.ms,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
  
  String _getProficiencyText(String level) {
    final int profLevel = int.tryParse(level) ?? 0;
    switch (profLevel) {
      case 1:
        return 'Basic';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      case 4:
        return 'Fluent';
      case 5:
        return 'Native';
      default:
        return 'Basic';
    }
  }
  
  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    MyColors myColors, {
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: myColors.forestGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: myColors.forestGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  icon,
                  size: 14,
                  color: myColors.forestGreen,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1, end: 0);
  }
}
