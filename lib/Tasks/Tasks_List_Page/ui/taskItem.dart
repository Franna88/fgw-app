import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final String title;
  final String field;
  final String portion;
  final String rowNumber;
  final DateTime dueDate;
  final bool isHighPriority;
  final bool isCompleted;
  final String taskId;
  final String priority;
  final String cropType;
  final Function(bool)? onStatusChanged;

  const TaskItem({
    Key? key,
    required this.title,
    required this.field,
    required this.portion,
    required this.rowNumber,
    required this.dueDate,
    this.isHighPriority = false,
    this.isCompleted = false,
    required this.taskId,
    required this.priority,
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
    final normalizedDueDate =
        DateTime(dueDate.year, dueDate.month, dueDate.day);

    return normalizedDueDate.difference(normalizedToday).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final daysLeft = _calculateDaysLeft();
    final isOverdue = daysLeft < 0;
    final bool isHighPriority = widget.priority.toLowerCase() == 'high';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                if (isHighPriority)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.priority_high, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'High Priority',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Text(
                  '${widget.field} - ${widget.portion}',
                  style: TextStyle(
                    color: myColors.forestGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: _isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                      if (widget.onStatusChanged != null) {
                        widget.onStatusChanged!(_isCompleted);
                      }
                    },
                    activeColor: myColors.forestGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Row ${widget.rowNumber}',
                        style: TextStyle(
                          color: myColors.forestGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration:
                              _isCompleted ? TextDecoration.lineThrough : null,
                          color: _isCompleted ? Colors.grey : Colors.black87,
                        ),
                      ),
                      if (widget.cropType.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Crop: ${widget.cropType}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  isOverdue
                      ? 'Overdue by ${-daysLeft} days'
                      : daysLeft == 0
                          ? 'Due today'
                          : '$daysLeft days left',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
