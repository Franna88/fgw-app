import 'package:flutter/material.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledDropdown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
  });

  @override
  _LabeledDropdownState createState() => _LabeledDropdownState();
}

class _LabeledDropdownState extends State<LabeledDropdown> {
  String? selectedValue;
  String? errorText;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  void validateInput(String? value) {
    if (widget.validator != null) {
      setState(() {
        errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
            widget.label,
            style: GoogleFonts.roboto(
              letterSpacing: 1.1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MyColors().offWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    hint: Text(
                      widget.hintText,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                      widget.onChanged(value);
                      validateInput(value);
                    },
                    items: widget.items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MyColors().offWhite,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
