import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Tasks/Tasks_List_Page/ui/taskItem.dart';
import 'package:farming_gods_way/Tasks/Create_Task/taskCreateFieldSelect.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TasksListPage extends StatefulWidget {
  final String? fieldId;
  final String? portionId;
  final String? rowNumber;
  final String? fieldName;
  final String? portionName;

  const TasksListPage({
    Key? key,
    this.fieldId,
    this.portionId,
    this.rowNumber,
    this.fieldName,
    this.portionName,
  }) : super(key: key);

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _selectedPriority = 'All';

  // Tasks list
  List<Map<String, dynamic>> _allTasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid scheduler issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      if (widget.rowNumber != null &&
          widget.portionId != null &&
          widget.fieldId != null) {
        // Load row-specific tasks
        final tasksSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('tasks')
            .where('fieldId', isEqualTo: widget.fieldId)
            .where('portionId', isEqualTo: widget.portionId)
            .where('rowNumber', isEqualTo: widget.rowNumber)
            .get();

        if (tasksSnapshot.docs.isEmpty) {
          _allTasks = [];
        } else {
          _allTasks = tasksSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? 'Untitled Task',
              'field': data['fieldName'] ?? widget.fieldName ?? 'Unknown Field',
              'portion': data['portionName'] ??
                  widget.portionName ??
                  'Unknown Portion',
              'dueDate':
                  (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              'priority': data['priority'] ?? 'Medium',
              'isCompleted': data['isCompleted'] ?? false,
              'cropType': data['cropType'] ?? 'Unknown',
              'fieldId': data['fieldId'] ?? widget.fieldId,
              'portionId': data['portionId'] ?? widget.portionId,
              'rowNumber': data['rowNumber'] ?? widget.rowNumber,
            };
          }).toList();
        }
      } else if (widget.portionId != null && widget.fieldId != null) {
        // Load portion-specific tasks (all rows)
        final tasksSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('tasks')
            .where('fieldId', isEqualTo: widget.fieldId)
            .where('portionId', isEqualTo: widget.portionId)
            .get();

        if (tasksSnapshot.docs.isEmpty) {
          _allTasks = [];
        } else {
          _allTasks = tasksSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? 'Untitled Task',
              'field': data['fieldName'] ?? widget.fieldName ?? 'Unknown Field',
              'portion': data['portionName'] ??
                  widget.portionName ??
                  'Unknown Portion',
              'dueDate':
                  (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              'priority': data['priority'] ?? 'Medium',
              'isCompleted': data['isCompleted'] ?? false,
              'cropType': data['cropType'] ?? 'Unknown',
              'fieldId': data['fieldId'] ?? widget.fieldId,
              'portionId': data['portionId'] ?? widget.portionId,
              'rowNumber': data['rowNumber'],
            };
          }).toList();
        }
      } else if (widget.fieldId != null) {
        // Load field-specific tasks
        final tasksSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('tasks')
            .where('fieldId', isEqualTo: widget.fieldId)
            .get();

        if (tasksSnapshot.docs.isEmpty) {
          _allTasks = [];
        } else {
          _allTasks = tasksSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? 'Untitled Task',
              'field': data['fieldName'] ?? widget.fieldName ?? 'Unknown Field',
              'portion': data['portionName'] ?? 'Unknown Portion',
              'dueDate':
                  (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              'priority': data['priority'] ?? 'Medium',
              'isCompleted': data['isCompleted'] ?? false,
              'cropType': data['cropType'] ?? 'Unknown',
              'fieldId': data['fieldId'] ?? widget.fieldId,
              'portionId': data['portionId'],
              'rowNumber': data['rowNumber'],
            };
          }).toList();
        }
      } else {
        // Load all user tasks
        final tasksSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('tasks')
            .get();

        if (tasksSnapshot.docs.isEmpty) {
          _allTasks = _getSampleTasks();
        } else {
          _allTasks = tasksSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? 'Untitled Task',
              'field': data['fieldName'] ?? 'Unknown Field',
              'portion': data['portionName'] ?? 'Unknown Portion',
              'dueDate':
                  (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              'priority': data['priority'] ?? 'Medium',
              'isCompleted': data['isCompleted'] ?? false,
              'cropType': data['cropType'] ?? 'Unknown',
              'fieldId': data['fieldId'],
              'portionId': data['portionId'],
              'rowNumber': data['rowNumber'],
            };
          }).toList();
        }
      }

      setState(() {
        _filteredTasks = _allTasks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() {
        // Use sample tasks if there's an error
        _allTasks = _getSampleTasks();
        _filteredTasks = _allTasks;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading tasks: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Sample tasks for demonstration
  List<Map<String, dynamic>> _getSampleTasks() {
    return [
      {
        'id': '1',
        'title': 'Prepare seedbed using God\'s Way standards',
        'field': 'North Field',
        'portion': 'Section A',
        'dueDate': DateTime.now().add(const Duration(days: 3)),
        'priority': 'High',
        'isCompleted': false,
        'cropType': 'Maize',
        'rowNumber': widget.rowNumber ?? 'Row 1',
      },
      {
        'id': '2',
        'title': 'Apply compost to bean rows',
        'field': 'South Field',
        'portion': 'Section B',
        'dueDate': DateTime.now().add(const Duration(days: 1)),
        'priority': 'Medium',
        'isCompleted': false,
        'cropType': 'Beans',
        'rowNumber': widget.rowNumber ?? 'Row 2',
      },
      {
        'id': '3',
        'title': 'Plant vegetable seedlings',
        'field': 'Garden',
        'portion': 'Raised Beds',
        'dueDate': DateTime.now().subtract(const Duration(days: 2)),
        'priority': 'Medium',
        'isCompleted': true,
        'cropType': 'Vegetables',
        'rowNumber': widget.rowNumber ?? 'Row 1',
      },
      {
        'id': '4',
        'title': 'Weed around fruit trees',
        'field': 'Orchard',
        'portion': 'All trees',
        'dueDate': DateTime.now().add(const Duration(days: 5)),
        'priority': 'Low',
        'isCompleted': false,
        'cropType': 'Fruit Trees',
        'rowNumber': widget.rowNumber ?? 'Row 3',
      },
      {
        'id': '5',
        'title': 'Harvest mature maize',
        'field': 'East Field',
        'portion': 'Whole field',
        'dueDate': DateTime.now().add(const Duration(days: 14)),
        'priority': 'High',
        'isCompleted': false,
        'cropType': 'Maize',
        'rowNumber': widget.rowNumber ?? 'Row 2',
      },
    ];
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
            task['cropType'].toLowerCase().contains(query) ||
            (task['rowNumber'] != null &&
                task['rowNumber'].toLowerCase().contains(query));

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

  Widget _buildFilterChip(
      String label, String selectedValue, Function(String) onSelected) {
    final myColors = MyColors();
    final isSelected = label == selectedValue;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onSelected(label);
            _filterTasks();
          }
        },
        backgroundColor: Colors.grey[100],
        selectedColor: myColors.lightGreen.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? myColors.forestGreen : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Future<void> _updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Update task completion status
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': isCompleted});

      // Now update the row progress if we have a specific row
      if (widget.portionId != null &&
          widget.rowNumber != null &&
          widget.fieldId != null) {
        // Find the field document containing this portion
        final fieldDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('cropFields')
            .doc(widget.fieldId)
            .get();

        if (fieldDoc.exists) {
          // Get the portion document
          final portionDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('cropFields')
              .doc(widget.fieldId)
              .collection('portions')
              .doc(widget.portionId)
              .get();

          if (portionDoc.exists) {
            final portionData = portionDoc.data();
            if (portionData != null && portionData['rows'] != null) {
              List<dynamic> rows = portionData['rows'];

              // Find the specific row
              for (int i = 0; i < rows.length; i++) {
                if (rows[i]['rowNumber'] == widget.rowNumber) {
                  // Get tasks for this row to recalculate progress
                  final tasksQuery = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .collection('tasks')
                      .where('fieldId', isEqualTo: widget.fieldId)
                      .where('portionId', isEqualTo: widget.portionId)
                      .where('rowNumber', isEqualTo: widget.rowNumber)
                      .get();

                  final tasks = tasksQuery.docs;
                  final totalTasks = tasks.length;
                  final completedTasks = tasks
                      .where((task) =>
                          (task.data()['isCompleted'] ?? false) == true)
                      .length;

                  // Calculate new progress
                  final progressValue =
                      totalTasks > 0 ? completedTasks / totalTasks : 0.0;

                  // Update the row's progress
                  rows[i]['progressValue'] = progressValue;
                  rows[i]['tasksCompleted'] = completedTasks;
                  rows[i]['totalTasks'] = totalTasks;

                  // Update the portion document
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .collection('cropFields')
                      .doc(widget.fieldId)
                      .collection('portions')
                      .doc(widget.portionId)
                      .update({'rows': rows});

                  break;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error updating task status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating task: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
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
            widget.rowNumber != null
                ? 'No tasks for ${widget.rowNumber}'
                : 'Try changing your filters or search term',
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
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();

    // Customize page title based on the context
    String pageTitle = 'Tasks';
    if (widget.rowNumber != null) {
      pageTitle = widget.rowNumber!;
    } else if (widget.portionName != null) {
      pageTitle = widget.portionName!;
    } else if (widget.fieldName != null) {
      pageTitle = widget.fieldName!;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            FgwTopBar(
              title: pageTitle,
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            // Filter section with divider
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ExpansionTile(
                title: Text(
                  'Filters',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: myColors.forestGreen,
                  ),
                ),
                leading: Icon(
                  Icons.filter_list,
                  color: myColors.forestGreen,
                ),
                iconColor: myColors.forestGreen,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              _buildFilterChip('All', _selectedFilter,
                                  (filter) {
                                setState(() => _selectedFilter = filter);
                              }),
                              _buildFilterChip('Outstanding', _selectedFilter,
                                  (filter) {
                                setState(() => _selectedFilter = filter);
                              }),
                              _buildFilterChip('Completed', _selectedFilter,
                                  (filter) {
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
                              _buildFilterChip('All', _selectedPriority,
                                  (filter) {
                                setState(() => _selectedPriority = filter);
                              }),
                              _buildFilterChip('High', _selectedPriority,
                                  (filter) {
                                setState(() => _selectedPriority = filter);
                              }),
                              _buildFilterChip('Medium', _selectedPriority,
                                  (filter) {
                                setState(() => _selectedPriority = filter);
                              }),
                              _buildFilterChip('Low', _selectedPriority,
                                  (filter) {
                                setState(() => _selectedPriority = filter);
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .slideY(begin: 0.1, end: 0),

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
                                title: task['title'] ?? 'Untitled Task',
                                field: task['field'] ?? 'Unknown Field',
                                portion: task['portion'] ?? 'Unknown Portion',
                                rowNumber: task['rowNumber'] ?? '',
                                dueDate: task['dueDate'] is Timestamp
                                    ? (task['dueDate'] as Timestamp).toDate()
                                    : (task['dueDate'] as DateTime),
                                priority: task['priority'] ?? 'Medium',
                                isCompleted: task['isCompleted'] ?? false,
                                taskId: task['id'] ?? '',
                                cropType: task['cropType'] ?? '',
                                onStatusChanged: (isCompleted) async {
                                  // First update the UI
                                  setState(() {
                                    // Update the task status in both lists
                                    task['isCompleted'] = isCompleted;

                                    // Find and update in the original list too
                                    final originalTask = _allTasks.firstWhere(
                                      (t) => t['id'] == task['id'],
                                      orElse: () => task,
                                    );
                                    originalTask['isCompleted'] = isCompleted;
                                  });

                                  // Then update Firestore if we have a valid task ID
                                  if (task['id'] != null) {
                                    await _updateTaskStatus(
                                        task['id'], isCompleted);
                                  }

                                  // Reapply filters in case completion status matters
                                  _filterTasks();
                                },
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 50.ms * index)
                                .slideY(begin: 0.1, end: 0);
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
              builder: (context) => TaskCreateFieldSelect(
                preSelectedFieldId: widget.fieldId,
                preSelectedPortionId: widget.portionId,
                preSelectedFieldName: widget.fieldName,
                preSelectedPortionName: widget.portionName,
                preSelectedRowNumber: widget.rowNumber,
              ),
            ),
          ).then((_) => _loadTasks()); // Reload tasks when returning
        },
        backgroundColor: myColors.forestGreen,
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
        elevation: 4,
      )
          .animate()
          .scale(delay: 300.ms, duration: 400.ms, curve: Curves.elasticOut),
    );
  }
}
