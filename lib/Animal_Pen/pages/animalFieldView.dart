import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/animalProfile.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/animalProfilesList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';
import '../../Inventory/inventory.dart';
import '../../Production_Records/productionRecords.dart';
import '../../Reminders/userReminders.dart';
import '../../Tasks/tasksHome.dart';

class AnimalFieldView extends StatefulWidget {
  final Map<String, String> field;
  const AnimalFieldView({super.key, required this.field});

  @override
  State<AnimalFieldView> createState() => _AnimalFieldViewState();
}

class _AnimalFieldViewState extends State<AnimalFieldView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  
  // Simulated data - would come from database in real app
  int maleCount = 3;
  int femaleCount = 3;

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1200));
    
    setState(() {
      _isLoading = false;
    });
    
    return Future.value();
  }

  IconData _getAnimalTypeIcon(String animalType) {
    switch (animalType) {
      case 'Sheep':
        return FontAwesomeIcons.pagelines;
      case 'Cattle':
        return FontAwesomeIcons.horse;
      case 'Pigs':
        return FontAwesomeIcons.piggyBank;
      case 'Chickens':
        return FontAwesomeIcons.dove;
      default:
        return FontAwesomeIcons.paw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: myColors.forestGreen,
          child: Container(
            height: MyUtility(context).height,
            width: MyUtility(context).width,
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
                  header: widget.field['name'] ?? 'Animal Field',
                  hasBackArrow: true,
                ).animate().fadeIn(duration: 300.ms),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        // Field info card
                        _buildFieldInfoCard(myColors, screenWidth),
                        
                        const SizedBox(height: 20),
                        
                        // Action buttons grid
                        _buildActionButtonsGrid(screenWidth),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.yellow,
        foregroundColor: myColors.black,
        onPressed: () {
          // Navigate to edit screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Edit feature coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildFieldInfoCard(MyColors myColors, double screenWidth) {
    final animalType = widget.field['animal'] ?? 'Unknown';
    
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with animal type and total count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FaIcon(
                      _getAnimalTypeIcon(animalType),
                      size: 18,
                      color: myColors.forestGreen,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      animalType,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: myColors.lightGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.group,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${maleCount + femaleCount} Animals',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: myColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Field photo and details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Field image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.field['image'] ?? 'images/livestock.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        animalType,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Field details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.field['name'] ?? 'Animal Field',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCountItem(Icons.male, 'Male', maleCount, myColors),
                      const SizedBox(height: 8),
                      _buildCountItem(Icons.female, 'Female', femaleCount, myColors),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      _buildCountItem(Icons.pets, 'Total', maleCount + femaleCount, myColors, 
                        isTotal: true, color: myColors.forestGreen),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Quick stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Health', '95%', Icons.favorite, Colors.redAccent),
                  _buildStatItem('Feed', '87%', Icons.restaurant, Colors.orangeAccent),
                  _buildStatItem('Growth', '92%', Icons.trending_up, Colors.greenAccent[700]!),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildCountItem(IconData icon, String label, int count, MyColors myColors, 
      {bool isTotal = false, Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.roboto(
            fontSize: 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count.toString(),
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.grey[800],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 22,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtonsGrid(double screenWidth) {
    final buttonWidth = (screenWidth - 45) / 2;
    
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Animal Profiles',
        'icon': Icons.pets,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnimalProfilesList()),
          );
        },
      },
      {
        'title': 'Tasks',
        'icon': Icons.check_circle_outline,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TasksHome()),
          );
        },
      },
      {
        'title': 'Reminders',
        'icon': Icons.notifications_active,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserReminders()),
          );
        },
      },
      {
        'title': 'Inventory',
        'icon': Icons.inventory_2,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Inventory()),
          );
        },
      },
      {
        'title': 'Production',
        'icon': Icons.trending_up,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductionRecords()),
          );
        },
      },
      {
        'title': 'Reports',
        'icon': Icons.bar_chart,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reports feature coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      },
    ];
    
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: List.generate(
        actions.length,
        (index) => _buildActionButton(
          actions[index]['title'],
          actions[index]['icon'],
          actions[index]['onTap'],
          buttonWidth,
          index,
        ),
      ),
    );
  }
  
  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap, double width, int index) {
    final myColors = MyColors();
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: myColors.lightGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: myColors.forestGreen,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate(delay: (100 * index).ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}
