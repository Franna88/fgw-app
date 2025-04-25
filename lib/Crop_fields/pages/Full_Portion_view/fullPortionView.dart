import 'package:farming_gods_way/Crop_fields/pages/Full_Portion_view/ui/portionRowTaskItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';
import '../../../Tasks/Tasks_List_Page/tasksListPage.dart';
import '../Create_Portion/ui/portionInfo.dart';

class FullPortionView extends StatefulWidget {
  const FullPortionView({super.key});

  @override
  State<FullPortionView> createState() => _FullPortionViewState();
}

class _FullPortionViewState extends State<FullPortionView> {
  bool _isLoading = false;
  String _portionType = 'Root Type';
  String _portionName = 'Portion A';
  String _crop = 'Carrot';
  int _rowCount = 5;
  
  // Sample data for rows
  final List<Map<String, dynamic>> _rows = [
    {
      'rowNumber': 'Row 1',
      'progressValue': 0.8,
      'rowFaze': 'Growth',
      'tasksCompleted': 4,
      'totalTasks': 5,
      'isActive': true,
    },
    {
      'rowNumber': 'Row 2',
      'progressValue': 1.0,
      'rowFaze': 'Harvested',
      'tasksCompleted': 6,
      'totalTasks': 6,
      'isActive': false,
    },
    {
      'rowNumber': 'Row 3',
      'progressValue': 0.5,
      'rowFaze': 'Preparation',
      'tasksCompleted': 2,
      'totalTasks': 4,
      'isActive': true,
    },
    {
      'rowNumber': 'Row 4',
      'progressValue': 0.3,
      'rowFaze': 'Preparation',
      'tasksCompleted': 1,
      'totalTasks': 3,
      'isActive': true,
    },
    {
      'rowNumber': 'Row 5',
      'progressValue': 0.0,
      'rowFaze': 'Not Started',
      'tasksCompleted': 0,
      'totalTasks': 4,
      'isActive': false,
    },
  ];
  
  void _navigateToTaskList(String rowNumber) {
    setState(() {
      _isLoading = true;
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TasksListPage()),
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
  
  String _getImagePath() {
    switch (_portionType.toLowerCase()) {
      case 'root type':
        return 'images/carrot.png';
      case 'leaf type':
        return 'images/spinach.png';
      case 'fruit type':
        return 'images/apple.png';
      default:
        return 'images/carrot.png';
    }
  }
  
  // Calculate overall progress
  double get _overallProgress {
    if (_rows.isEmpty) return 0.0;
    
    final totalCompleted = _rows.fold<int>(0, (sum, row) => sum + (row['tasksCompleted'] as int));
    final totalTasks = _rows.fold<int>(0, (sum, row) => sum + (row['totalTasks'] as int));
    
    return totalTasks > 0 ? totalCompleted / totalTasks : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    height: screenHeight - topPadding,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          myColors.forestGreen,
                          myColors.lightGreen,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        CornerHeaderContainer(
                          header: _portionName,
                          hasBackArrow: true,
                        ).animate().fadeIn(duration: 300.ms),
                        
                        // Main content area
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                // Portion info card
                                Container(
                                  width: screenWidth * 0.9,
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
                                        // Header section with type and image
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Type badge
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, 
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: myColors.lightGreen.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(
                                                      color: myColors.lightGreen,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    _portionType,
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: myColors.forestGreen,
                                                    ),
                                                  ),
                                                ),
                                                
                                                const SizedBox(height: 16),
                                                
                                                // Row count
                                                Text(
                                                  '$_rowCount Rows',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                
                                                const SizedBox(height: 8),
                                                
                                                // Crop name
                                                Row(
                                                  children: [
                                                    FaIcon(
                                                      _portionType.toLowerCase().contains('root')
                                                          ? FontAwesomeIcons.carrot
                                                          : _portionType.toLowerCase().contains('leaf')
                                                              ? FontAwesomeIcons.seedling
                                                              : FontAwesomeIcons.apple,
                                                      size: 16,
                                                      color: myColors.forestGreen,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      _crop,
                                                      style: GoogleFonts.robotoSlab(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            
                                            // Crop image
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                _getImagePath(),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        const Divider(),
                                        const SizedBox(height: 16),
                                        
                                        // Progress section
                                        Text(
                                          'Overall Progress',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 8),
                                        
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: LinearProgressIndicator(
                                                  value: _overallProgress,
                                                  minHeight: 10,
                                                  backgroundColor: Colors.grey[200],
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    _overallProgress >= 1.0
                                                        ? myColors.green
                                                        : _overallProgress >= 0.5
                                                            ? myColors.yellow
                                                            : myColors.lightBlue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${(_overallProgress * 100).toInt()}%',
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: _overallProgress >= 1.0
                                                    ? myColors.green
                                                    : _overallProgress >= 0.5
                                                        ? myColors.yellow
                                                        : myColors.lightBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                                
                                const SizedBox(height: 20),
                                
                                // Planting info card
                                Container(
                                  width: screenWidth * 0.9,
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
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.ruler,
                                              size: 16,
                                              color: myColors.forestGreen,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Planting Information',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 12),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                        
                                        PortionInfo(
                                          text: 'Estimated harvest amount',
                                          amounts: '55 plants',
                                        ),
                                        PortionInfo(
                                          text: 'Planting Depth',
                                          amounts: '3 cm',
                                        ),
                                        PortionInfo(
                                          text: 'Distance in row',
                                          amounts: '12 cm',
                                        ),
                                        PortionInfo(
                                          text: 'Distance between row',
                                          amounts: '12 cm',
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                                
                                const SizedBox(height: 20),
                                
                                // Row tasks header
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Row Tasks',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.tasks,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'All Rows',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 600.ms),
                                
                                const SizedBox(height: 12),
                                
                                // Row tasks list
                                Container(
                                  width: screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _rows.length,
                                    itemBuilder: (context, index) {
                                      final row = _rows[index];
                                      return GestureDetector(
                                        onTap: () => _navigateToTaskList(row['rowNumber']),
                                        child: PortionRowTaskItem(
                                          row: row['rowNumber'],
                                          progressValue: row['progressValue'],
                                          rowFaze: row['rowFaze'],
                                          onTap: () => _navigateToTaskList(row['rowNumber']),
                                        ).animate().fadeIn(
                                          duration: 400.ms,
                                          delay: 50.ms * index,
                                        ),
                                      );
                                    },
                                  ),
                                ).animate().fadeIn(duration: 700.ms),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Add row functionality coming soon'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: myColors.forestGreen,
            ),
          );
        },
        backgroundColor: myColors.forestGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 300.ms),
    );
  }
}
