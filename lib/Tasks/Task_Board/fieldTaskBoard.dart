import 'package:farming_gods_way/CommonUi/cornerHeaderContainer.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/Tasks/Task_Board/ui/fieldTaskBoardItem.dart';
import 'package:farming_gods_way/Tasks/Tasks_List_Page/tasksListPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FieldTaskBoard extends StatefulWidget {
  const FieldTaskBoard({super.key});

  @override
  State<FieldTaskBoard> createState() => _FieldTaskBoardState();
}

class _FieldTaskBoardState extends State<FieldTaskBoard> {
  final List<String> _phaseFilters = ['All Phases', 'Preparation', 'Grow out', 'Harvest'];
  String _selectedPhase = 'All Phases';
  bool _showCompletedTasks = true;
  bool _isLoading = false;
  
  // Sample tasks data - in a real app this would come from a database
  final List<Map<String, dynamic>> _tasks = [
    {
      'row': 'Row 1',
      'tasksComplete': '3/3',
      'faze': 'Grow out',
      'progressValue': 1.0,
      'isImportant': false,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'row': 'Row 2',
      'tasksComplete': '3/3',
      'faze': 'Grow out',
      'progressValue': 1.0,
      'isImportant': false,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'row': 'Row 3',
      'tasksComplete': '1/2',
      'faze': 'Preparation',
      'progressValue': 0.5,
      'isImportant': true,
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 8)),
    },
    {
      'row': 'Row 4',
      'tasksComplete': '2/6',
      'faze': 'Preparation',
      'progressValue': 0.4,
      'isImportant': false,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'row': 'Row 5',
      'tasksComplete': '0/5',
      'faze': 'Preparation',
      'progressValue': 0,
      'isImportant': false,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'row': 'Row 6',
      'tasksComplete': '0/6',
      'faze': 'Preparation',
      'progressValue': 0,
      'isImportant': false,
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 12)),
    },
  ];

  List<Map<String, dynamic>> get filteredTasks {
    return _tasks.where((task) {
      // Filter by phase if not "All Phases"
      if (_selectedPhase != 'All Phases' && task['faze'] != _selectedPhase) {
        return false;
      }
      
      // Filter out completed tasks if not showing them
      if (!_showCompletedTasks && task['progressValue'] >= 1.0) {
        return false;
      }
      
      return true;
    }).toList();
  }

  void _navigateToTaskList(String row) {
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Tasks',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Phase',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _phaseFilters.map((phase) {
                    final isSelected = _selectedPhase == phase;
                    return FilterChip(
                      label: Text(phase),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedPhase = phase;
                        });
                      },
                      selectedColor: MyColors().lightGreen.withOpacity(0.2),
                      checkmarkColor: MyColors().forestGreen,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Show Completed Tasks',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _showCompletedTasks,
                      onChanged: (value) {
                        setModalState(() {
                          _showCompletedTasks = value;
                        });
                      },
                      activeColor: MyColors().forestGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Apply filters from modal state
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors().forestGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    // Calculate task progress statistics
    final totalTasks = _tasks.length;
    final completedTasks = _tasks.where((task) => task['progressValue'] >= 1.0).length;
    final inProgressTasks = _tasks.where((task) => task['progressValue'] > 0 && task['progressValue'] < 1.0).length;
    final notStartedTasks = _tasks.where((task) => task['progressValue'] == 0).length;
    final progressValue = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

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
                        colors: [myColors.forestGreen, myColors.lightGreen],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: [
                          CornerHeaderContainer(
                            header: 'Tasks',
                            hasBackArrow: true,
                          ).animate().fadeIn(duration: 300.ms),
                          
                          const SizedBox(height: 20),
                          
                          // Field info card with statistics
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Field header
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: myColors.lightGreen.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: FaIcon(
                                          FontAwesomeIcons.leaf,
                                          size: 18,
                                          color: myColors.forestGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Field A',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Portion B',
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Divider
                                Divider(
                                  color: Colors.grey[200],
                                  height: 1,
                                ),
                                
                                // Stats
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Progress bar
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Overall Progress',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: progressValue >= 1.0 
                                                  ? myColors.green.withOpacity(0.1)
                                                  : myColors.yellow.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(
                                                color: progressValue >= 1.0 
                                                    ? myColors.green 
                                                    : myColors.yellow,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              '$completedTasks/$totalTasks',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: progressValue,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey[200],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            progressValue >= 1.0 ? myColors.green : myColors.yellow,
                                          ),
                                        ),
                                      ),
                                      
                                      // Stats row
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildStatCard(
                                              '$completedTasks',
                                              'Completed',
                                              myColors.green,
                                              FontAwesomeIcons.checkCircle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildStatCard(
                                              '$inProgressTasks',
                                              'In Progress',
                                              myColors.yellow,
                                              FontAwesomeIcons.spinner,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildStatCard(
                                              '$notStartedTasks',
                                              'Not Started',
                                              Colors.grey,
                                              FontAwesomeIcons.circleStop,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                          
                          const SizedBox(height: 20),
                          
                          // Task list header with filters
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tasks by Row',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: _showFilterDialog,
                                child: Container(
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
                                        FontAwesomeIcons.filter,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _selectedPhase == 'All Phases'
                                            ? 'Filter'
                                            : _selectedPhase,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 500.ms),
                          
                          const SizedBox(height: 10),
                          
                          // Task list
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: filteredTasks.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.clipboardList,
                                            size: 48,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No tasks found',
                                            style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              color: Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Try adjusting your filters',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(16),
                                        itemCount: filteredTasks.length,
                                        itemBuilder: (context, index) {
                                          final task = filteredTasks[index];
                                          return FieldTaskBoardItem(
                                            row: task['row'],
                                            tasksComplete: task['tasksComplete'],
                                            faze: task['faze'],
                                            progressValue: task['progressValue'],
                                            isImportant: task['isImportant'],
                                            onTap: () => _navigateToTaskList(task['row']),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ).animate().fadeIn(duration: 600.ms),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Add new task functionality coming soon'),
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

  Widget _buildStatCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
