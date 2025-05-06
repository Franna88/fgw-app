import 'package:farming_gods_way/CommonUi/Buttons/myDropDownButton.dart';
import 'package:farming_gods_way/Production_Records/pages/addProductionRecord.dart';
import 'package:farming_gods_way/Production_Records/ui/productionRecordItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class ProductionRecords extends StatefulWidget {
  const ProductionRecords({super.key});

  @override
  State<ProductionRecords> createState() => _ProductionRecordsState();
}

class _ProductionRecordsState extends State<ProductionRecords> {
  List<Map<String, dynamic>> productionRecords = [];
  String? selectedMonth;
  bool isLoading = false;

  final List<String> months = [
    'All Months',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = 'All Months';
    _loadProductionRecords();
  }

  Future<void> _loadProductionRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('production_records')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        productionRecords = querySnapshot.docs.map((doc) {
          final data = doc.data();
          final timestamp = data['date'] as Timestamp;
          final date = timestamp.toDate();
          return {
            'id': doc.id,
            'date': '${date.day} ${_getMonthName(date.month)}, ${date.year}',
            'product': data['product'] ?? 'Unknown Product',
            'productQuantity':
                '${data['quantity'] ?? 0} ${data['unit'] ?? 'kg'}',
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading production records: $e');
      setState(() {
        productionRecords = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading records: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addRecord(Map<String, dynamic> record) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Parse the date string back to DateTime
      final dateParts = record['date'].split(' ');
      final day = int.parse(dateParts[0]);
      final month = _getMonthNumber(dateParts[1].replaceAll(',', ''));
      final year = int.parse(dateParts[2]);
      final date = DateTime(year, month, day);

      // Parse quantity and unit
      final quantityParts = record['productQuantity'].split(' ');
      final quantity = double.parse(quantityParts[0]);
      final unit = quantityParts[1];

      // Save to Firebase under the user's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('production_records')
          .add({
        'date': Timestamp.fromDate(date),
        'product': record['product'],
        'quantity': quantity,
        'unit': unit,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': currentUser.uid, // Add user ID for additional security
      });

      // Reload records
      _loadProductionRecords();
    } catch (e) {
      print('Error adding record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding record: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _getMonthNumber(String monthName) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months.indexOf(monthName) + 1;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords =
        selectedMonth == null || selectedMonth == 'All Months'
            ? productionRecords
            : productionRecords
                .where((record) => record['date']!.contains(selectedMonth!))
                .toList();

    return Scaffold(
      backgroundColor: MyColors().forestGreen.withOpacity(0.9),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'images/loginImg.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ).animate().fadeIn(duration: 300.ms),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Production Records",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Track your farm's harvest output",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Main content container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add record button
                        ElevatedButton.icon(
                          onPressed: () async {
                            final newRecord = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddProductionRecord(),
                              ),
                            );
                            if (newRecord != null) {
                              _addRecord(newRecord);
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Record Entry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors().yellow,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 25),

                        // Filter section
                        Row(
                          children: [
                            Text(
                              "Filter by Month:",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedMonth,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: MyColors().forestGreen),
                                  items: months.map((String month) {
                                    return DropdownMenuItem<String>(
                                      value: month,
                                      child: Text(month),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMonth = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 100.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 25),

                        // Records list
                        Expanded(
                          child: isLoading
                              ? _buildLoadingState()
                              : filteredRecords.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      itemCount: filteredRecords.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final record = filteredRecords[index];
                                        return ProductionRecordItem(
                                          date: record['date']!,
                                          product: record['product']!,
                                          productQuantity:
                                              record['productQuantity']!,
                                        ).animate().fadeIn(
                                              duration: 400.ms,
                                              delay: Duration(
                                                  milliseconds: 50 * index),
                                            );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.05, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductionRecord(),
            ),
          );
          if (newRecord != null) {
            _addRecord(newRecord);
          }
        },
        backgroundColor: MyColors().yellow,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.clipboardList,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            "No production records found",
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedMonth == 'All Months'
                ? "Add your first harvest record"
                : "No records for $selectedMonth",
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              final newRecord = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductionRecord(),
                ),
              );
              if (newRecord != null) {
                _addRecord(newRecord);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Add First Record"),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors().yellow,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: MyColors().forestGreen,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading records...",
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
