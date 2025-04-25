import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final String title;
  final String field;
  final String portion;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;
  final String cropType;
  final Function(bool)? onStatusChanged;
  
  const TaskItem({
    Key? key, 
    required this.title,
    required this.field,
    required this.portion,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.cropType,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _isCompleted;
  
  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }
  
  String _formatDueDate() {
    return DateFormat('yyyy/MM/dd').format(widget.dueDate);
  }
  
  int _calculateDaysLeft() {
    final today = DateTime.now();
    final dueDate = widget.dueDate;
    
    // Set both dates to the start of the day for accurate calculation
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedDueDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    return normalizedDueDate.difference(normalizedToday).inDays;
  }
  
  IconData _getCropTypeIcon() {
    switch (widget.cropType.toLowerCase()) {
      case 'maize':
        return FontAwesomeIcons.wheatAwn;
      case 'beans':
        return FontAwesomeIcons.seedling;
      case 'vegetables':
        return FontAwesomeIcons.carrot;
      case 'fruit trees':
        return FontAwesomeIcons.apple;
      default:
        return FontAwesomeIcons.leaf;
    }
  }
  
  Color _getPriorityColor(MyColors colors) {
    switch (widget.priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return colors.yellow;
      case 'low':
        return colors.forestGreen;
      default:
        return colors.forestGreen;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final daysLeft = _calculateDaysLeft();
    final isOverdue = daysLeft < 0;
    
    return Container(
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
      ),
      child: Column(
        children: [
          // Priority indicator
          Container(
            height: 4,
            width: double.infinity,
            color: _getPriorityColor(myColors),
          ),
          
          // Task content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with location and crop type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Field and portion
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: myColors.forestGreen,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${widget.field} - ${widget.portion}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Crop type
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: myColors.lightGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            _getCropTypeIcon(),
                            size: 12,
                            color: myColors.forestGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.cropType,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: myColors.forestGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Task with checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox
                    Transform.scale(
                      scale: 1.1,
                      child: Checkbox(
                        value: _isCompleted,
                        activeColor: myColors.forestGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isCompleted = value ?? false;
                          });
                          if (widget.onStatusChanged != null) {
                            widget.onStatusChanged!(_isCompleted);
                          }
                        },
                      ),
                    ),
                    
                    // Task title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isCompleted ? Colors.grey : Colors.black87,
                            decoration: _isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Due date
                Padding(
                  padding: const EdgeInsets.only(left: 42, top: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOverdue ? Colors.red.withOpacity(0.1) : myColors.yellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isOverdue ? Colors.red.withOpacity(0.3) : myColors.yellow.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOverdue ? Icons.warning_amber_rounded : Icons.calendar_today,
                          size: 14,
                          color: isOverdue ? Colors.red : myColors.forestGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOverdue 
                              ? 'Overdue by ${daysLeft.abs()} days' 
                              : daysLeft == 0
                                ? 'Due today'
                                : 'Due in $daysLeft days (${_formatDueDate()})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isOverdue ? Colors.red : myColors.forestGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Priority tag
                if (widget.priority.toLowerCase() == 'high')
                  Padding(
                    padding: const EdgeInsets.only(left: 42, top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.priority_high,
                            size: 12,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'HIGH PRIORITY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
