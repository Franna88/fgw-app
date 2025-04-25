import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryGuideItem extends StatelessWidget {
  final Function() onTap;
  final String image;
  final String name;
  
  const CategoryGuideItem({
    super.key,
    required this.image,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Background image
                Hero(
                  tag: 'item_${name}_image',
                  child: Image.asset(
                    image,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                      stops: const [0.5, 0.8, 1.0],
                    ),
                  ),
                ),
                
                // Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 3,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: myColors.yellow,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: myColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: myColors.forestGreen,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Optional content-specific icon in corner
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: myColors.forestGreen.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      _getIconForName(name),
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
  
  IconData _getIconForName(String name) {
    switch (name.toLowerCase()) {
      case 'tomatoes':
        return FontAwesomeIcons.seedling;
      case 'potatoes':
        return FontAwesomeIcons.seedling;
      case 'corn':
        return FontAwesomeIcons.wheatAwn;
      case 'spinach':
        return FontAwesomeIcons.leaf;
      case 'carrot':
        return FontAwesomeIcons.carrot;
      case 'beetroot':
        return FontAwesomeIcons.seedling;
      case 'cattle':
        return FontAwesomeIcons.cow;
      case 'goats':
        return FontAwesomeIcons.paw;
      case 'chickens':
        return FontAwesomeIcons.kiwiBird;
      case 'aphids':
        return FontAwesomeIcons.bug;
      case 'beetles':
        return FontAwesomeIcons.bug;
      case 'fungus':
        return FontAwesomeIcons.disease;
      case 'composting':
        return FontAwesomeIcons.recycle;
      case 'mulching':
        return FontAwesomeIcons.layerGroup;
      case 'crop rotation':
        return FontAwesomeIcons.rotate;
      default:
        return FontAwesomeIcons.seedling;
    }
  }
}
