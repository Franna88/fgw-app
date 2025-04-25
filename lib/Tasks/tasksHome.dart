import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateFieldSelect.dart';
import 'package:farming_gods_way/Tasks/Task_Board/fieldTaskBoard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../Constants/myutility.dart';

class TasksHome extends StatefulWidget {
  const TasksHome({super.key});

  @override
  State<TasksHome> createState() => _TasksHomeState();
}

class _TasksHomeState extends State<TasksHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  
  // Sample data for tasks
  final List<Map<String, dynamic>> _fields = [
    {
      'name': 'Field A',
      'portions': [
        {
          'name': 'Portion 1',
          'type': 'Leaf',
          'tasks': 12,
          'completed': 5,
          'priority': 'high'
        },
        {
          'name': 'Portion 2',
          'type': 'Root',
          'tasks': 8,
          'completed': 8,
          'priority': 'medium'
        }
      ]
    },
    {
      'name': 'Field B',
      'portions': [
        {
          'name': 'North Section',
          'type': 'Fruit',
          'tasks': 15,
          'completed': 3,
          'priority': 'medium'
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority) {
    final myColors = MyColors();
    switch (priority.toLowerCase()) {
      case 'high':
        return myColors.red;
      case 'medium':
        return myColors.yellow;
      default:
        return myColors.green;
    }
  }
  
  IconData _getCropTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'leaf':
        return FontAwesomeIcons.leaf;
      case 'root':
        return FontAwesomeIcons.carrot;
      case 'fruit':
        return FontAwesomeIcons.apple;
      default:
        return FontAwesomeIcons.seedling;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with title
            const FgwTopBar(title: 'Tasks'),
            
            // Tab bar for filtering
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: myColors.lightGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: myColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Today'),
                  Tab(text: 'Overdue'),
                ],
              ),
            ),
            
            // Add task button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CommonButton(
                customHeight: 45,
                customWidth: double.infinity,
                buttonText: 'Add New Task',
                textColor: myColors.black,
                buttonColor: myColors.yellow,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskCreateFieldSelect(),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tasks list area
            Expanded(
              child: Container(
                width: double.infinity,
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                      controller: _tabController,
                      children: [
                        // All tasks tab
                        _buildTasksListByField(),
                        
                        // Today's tasks tab
                        _buildTasksByStatus(
                          title: "Today's Tasks",
                          message: "No tasks scheduled for today",
                          icon: FontAwesomeIcons.calendarDay,
                        ),
                        
                        // Overdue tasks tab
                        _buildTasksByStatus(
                          title: "Overdue Tasks",
                          message: "No overdue tasks - You're on track!",
                          icon: FontAwesomeIcons.check,
                          iconColor: myColors.green,
                        ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.lightGreen,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskCreateFieldSelect(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildTasksListByField() {
    if (_fields.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _fields.length,
      itemBuilder: (context, fieldIndex) {
        final field = _fields[fieldIndex];
        final portions = field['portions'] as List<Map<String, dynamic>>;
        
        // Skip fields with no portions
        if (portions.isEmpty) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                field['name'] as String,
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Portions in this field
            ...portions.map((portion) {
              final progress = portion['completed'] / portion['tasks'];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ModernCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FieldTaskBoard(),
                      ),
                    );
                  },
                  animate: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Portion header and status
                      Row(
                        children: [
                          // Crop type icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColors().lightGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FaIcon(
                              _getCropTypeIcon(portion['type'] as String),
                              color: MyColors().forestGreen,
                              size: 16,
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Portion info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${portion['name']} (${portion['type']})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Field: ${field['name']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Priority indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(portion['priority'] as String),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (portion['priority'] as String).toUpperCase(),
                              style: TextStyle(
                                color: (portion['priority'] as String).toLowerCase() == 'high' 
                                    ? Colors.white 
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Progress section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Completion text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Task Completion',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${portion['completed']}/${portion['tasks']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Progress bar
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(progress),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            // Add divider except for last field
            if (fieldIndex < _fields.length - 1)
              const Divider(height: 32),
          ],
        );
      },
    );
  }
  
  Widget _buildTasksByStatus({
    required String title,
    required String message,
    required IconData icon,
    Color? iconColor,
  }) {
    // For demo purposes, showing empty state for these tabs
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 48,
              color: iconColor ?? Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: MyColors().forestGreen),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View All Tasks',
                style: TextStyle(color: MyColors().forestGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.clipboardList,
              size: 52,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'No Tasks Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create a task to start managing your field work',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskCreateFieldSelect(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create First Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors().forestGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getProgressColor(double value) {
    final myColors = MyColors();
    if (value >= 1.0) return myColors.green;
    if (value > 0.6) return myColors.lightGreen;
    if (value > 0.3) return myColors.yellow;
    return myColors.red;
  }
}
