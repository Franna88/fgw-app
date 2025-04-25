import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class FarmItemGuide extends StatefulWidget {
  final String category;
  final String itemName;
  final String imagePath;
  
  const FarmItemGuide({
    super.key, 
    required this.category,
    required this.itemName,
    required this.imagePath,
  });

  @override
  State<FarmItemGuide> createState() => _FarmItemGuideState();
}

class _FarmItemGuideState extends State<FarmItemGuide> {
  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Description',
      'icon': FontAwesomeIcons.circleInfo,
      'content': 'This is a popular crop grown worldwide. It is valued for its taste, nutritional content, and versatility in cooking.'
    },
    {
      'title': 'Growing Conditions',
      'icon': FontAwesomeIcons.cloudSun,
      'content': 'Requires full sun exposure and well-drained soil. Ideal temperature is between 21-24°C (70-75°F). Plant after the threat of frost has passed.'
    },
    {
      'title': 'Planting Guide',
      'icon': FontAwesomeIcons.seedling,
      'content': 'Space plants about 45-60cm (18-24 inches) apart. Dig a hole deeper than the root ball and plant firmly, watering thoroughly after planting.'
    },
    {
      'title': 'Care Instructions',
      'icon': FontAwesomeIcons.handHoldingDroplet,
      'content': 'Water regularly, keeping soil moist but not waterlogged. Apply mulch to conserve moisture and suppress weeds. Support taller varieties with stakes or cages.'
    },
    {
      'title': 'Pest and Disease Management',
      'icon': FontAwesomeIcons.bug,
      'content': 'Watch for aphids, caterpillars, and fungal diseases. Use companion planting with marigolds to deter pests naturally. Ensure good air circulation to prevent disease.'
    },
    {
      'title': 'Harvesting',
      'icon': FontAwesomeIcons.basketShopping,
      'content': 'Harvest when fully ripened for best flavor. Cut or gently twist fruits from the plant. Store at room temperature for best taste.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
          ),
          child: Column(
            children: [
              FgwTopBar(),
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: widget.itemName,
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  width: MyUtility(context).width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero image section
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                widget.imagePath,
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.itemName,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
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
                                          widget.category,
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Content sections
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _sections.asMap().entries.map((entry) {
                              final index = entry.key;
                              final section = entry.value;
                              
                              return _buildSection(
                                title: section['title'],
                                icon: section['icon'],
                                content: section['content'],
                                index: index,
                                color: myColors,
                              );
                            }).toList(),
                          ),
                        ),
                        
                        // Related items suggestion
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommended Methods',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: myColors.forestGreen,
                                ),
                              ).animate().fadeIn(delay: 800.ms),
                              const SizedBox(height: 15),
                              _buildRecommendationChip(
                                'God\'s Way Composting',
                                myColors.forestGreen,
                              ),
                              _buildRecommendationChip(
                                'Biblical Farming Principles',
                                myColors.forestGreen,
                              ),
                              _buildRecommendationChip(
                                'Natural Pest Management',
                                myColors.forestGreen,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    required int index,
    required MyColors color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.lightGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: color.lightGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  icon,
                  size: 18,
                  color: color.forestGreen,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.forestGreen,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              content,
              style: GoogleFonts.roboto(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: 300 + (index * 100)),
    ).slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildRecommendationChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          // Navigate to recommendation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Coming soon: $label details'),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.bookBible,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: color,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: 900 + (_sections.length * 100)),
    ).slideX(begin: 0.1, end: 0);
  }
}
