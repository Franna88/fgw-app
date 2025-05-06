import 'package:farming_gods_way/CommonUi/Buttons/counterWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class InventoryItems extends StatefulWidget {
  final String image;
  final String name;
  final int count;
  final String unit;
  final String? notes;
  final double? unitCost;
  final ValueChanged<int> onChanged;

  const InventoryItems({
    super.key,
    required this.image,
    required this.name,
    required this.count,
    required this.onChanged,
    required this.unit,
    this.notes,
    this.unitCost,
  });

  @override
  State<InventoryItems> createState() => _InventoryItemsState();
}

class _InventoryItemsState extends State<InventoryItems> {
  bool _showNotes = false;

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: myColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: myColors.lightGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          icon: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                          onPressed: () {
                            if (widget.count > 0) {
                              widget.onChanged(widget.count - 1);
                            }
                          },
                        ),
                        Text(
                          widget.count.toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          onPressed: () {
                            widget.onChanged(widget.count + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (widget.unitCost != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• R${widget.unitCost!.toStringAsFixed(2)}/${widget.unit}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: myColors.forestGreen,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
