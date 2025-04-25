import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Tasks/Tasks_List_Page/ui/taskItem.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateFieldSelect.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({Key? key}) : super(key: key);

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _selectedFilter = 'All';
  String _selectedPriority = 'All';
  
  // Sample task data - would come from a database in a real app
  final List<Map<String, dynamic>> _allTasks = [
    {
      'title': 'Prepare seedbed using God\'s Way standards',
      'field': 'North Field',
      'portion': 'Section A',
      'dueDate': DateTime.now().add(const Duration(days: 3)),
      'priority': 'High',
      'isCompleted': false,
      'cropType': 'Maize',
    },
    {
      'title': 'Apply compost to bean rows',
      'field': 'South Field',
      'portion': 'Section B',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'priority': 'Medium',
      'isCompleted': false,
      'cropType': 'Beans',
    },
    {
      'title': 'Plant vegetable seedlings',
      'field': 'Garden',
      'portion': 'Raised Beds',
      'dueDate': DateTime.now().subtract(const Duration(days: 2)),
      'priority': 'Medium',
      'isCompleted': true,
      'cropType': 'Vegetables',
    },
    {
      'title': 'Weed around fruit trees',
      'field': 'Orchard',
      'portion': 'All trees',
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'priority': 'Low',
      'isCompleted': false,
      'cropType': 'Fruit Trees',
    },
    {
      'title': 'Harvest mature maize',
      'field': 'East Field',
      'portion': 'Whole field',
      'dueDate': DateTime.now().add(const Duration(days: 14)),
      'priority': 'High',
      'isCompleted': false,
      'cropType': 'Maize',
    },
  ];
  
  List<Map<String, dynamic>> _filteredTasks = [];
  
  @override
  void initState() {
    super.initState();
    _filteredTasks = _allTasks;
    _searchController.addListener(_filterTasks);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterTasks() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredTasks = _allTasks.where((task) {
        // Apply text search
        final matchesQuery = query.isEmpty ||
            task['title'].toLowerCase().contains(query) ||
            task['field'].toLowerCase().contains(query) ||
            task['portion'].toLowerCase().contains(query) ||
            task['cropType'].toLowerCase().contains(query);
        
        // Apply completion filter
        bool matchesStatus = true;
        if (_selectedFilter == 'Completed') {
          matchesStatus = task['isCompleted'] == true;
        } else if (_selectedFilter == 'Outstanding') {
          matchesStatus = task['isCompleted'] == false;
        }
        
        // Apply priority filter
        bool matchesPriority = true;
        if (_selectedPriority != 'All') {
          matchesPriority = task['priority'] == _selectedPriority;
        }
        
        return matchesQuery && matchesStatus && matchesPriority;
      }).toList();
    });
  }
  
  Widget _buildFilterChip(String label, String currentFilter, Function(String) onSelected) {
    final myColors = MyColors();
    final isSelected = currentFilter == label;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        selectedColor: myColors.forestGreen,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? myColors.forestGreen : Colors.grey.shade300,
          ),
        ),
        onSelected: (selected) {
          onSelected(label);
          _filterTasks();
        },
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0, duration: 300.ms);
  }
  
  Widget _buildEmptyState() {
    final myColors = MyColors();
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[300],
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            'Try changing your filters or search term',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedFilter = 'All';
                _selectedPriority = 'All';
                _filteredTasks = _allTasks;
              });
            },
            icon: Icon(Icons.refresh, color: myColors.forestGreen),
            label: Text(
              'Reset Filters',
              style: TextStyle(color: myColors.forestGreen),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: myColors.forestGreen),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            FgwTopBar(
              title: 'Tasks',
            ),
            
            // Search bar with rounded design
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Icons.search, color: myColors.forestGreen),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            
            // Filter section with divider
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with reset button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Tasks',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Reset all filters
                            setState(() {
                              _searchController.clear();
                              _selectedFilter = 'All';
                              _selectedPriority = 'All';
                              _filteredTasks = _allTasks;
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Reset'),
                          style: TextButton.styleFrom(
                            foregroundColor: myColors.forestGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(),
                    
                    // Status filter
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.clipboardCheck,
                          size: 14,
                          color: myColors.forestGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status:',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', _selectedFilter, (filter) {
                            setState(() => _selectedFilter = filter);
                          }),
                          _buildFilterChip('Outstanding', _selectedFilter, (filter) {
                            setState(() => _selectedFilter = filter);
                          }),
                          _buildFilterChip('Completed', _selectedFilter, (filter) {
                            setState(() => _selectedFilter = filter);
                          }),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Priority filter
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.flag,
                          size: 14,
                          color: myColors.forestGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Priority:',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', _selectedPriority, (filter) {
                            setState(() => _selectedPriority = filter);
                          }),
                          _buildFilterChip('High', _selectedPriority, (filter) {
                            setState(() => _selectedPriority = filter);
                          }),
                          _buildFilterChip('Medium', _selectedPriority, (filter) {
                            setState(() => _selectedPriority = filter);
                          }),
                          _buildFilterChip('Low', _selectedPriority, (filter) {
                            setState(() => _selectedPriority = filter);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            
            // Task count with subtle container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: myColors.lightGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: myColors.lightGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 18,
                    color: myColors.forestGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_filteredTasks.length} tasks found',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: myColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            
            // Task list with animation
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TaskItem(
                                title: task['title'],
                                field: task['field'],
                                portion: task['portion'],
                                dueDate: task['dueDate'],
                                priority: task['priority'],
                                isCompleted: task['isCompleted'],
                                cropType: task['cropType'],
                                onStatusChanged: (isCompleted) {
                                  setState(() {
                                    // Update the task status in both lists
                                    task['isCompleted'] = isCompleted;
                                    
                                    // Find and update in the original list too
                                    final originalTask = _allTasks.firstWhere(
                                      (t) => t['title'] == task['title'],
                                      orElse: () => task,
                                    );
                                    originalTask['isCompleted'] = isCompleted;
                                    
                                    // Reapply filters in case completion status matters
                                    _filterTasks();
                                  });
                                },
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 50.ms * index).slideY(begin: 0.1, end: 0);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskCreateFieldSelect(),
            ),
          );
        },
        backgroundColor: myColors.forestGreen,
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
        elevation: 4,
      ).animate().scale(delay: 300.ms, duration: 400.ms, curve: Curves.elasticOut),
    );
  }
}
