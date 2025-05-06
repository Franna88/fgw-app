import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/Crop_fields/pages/farmPortions/ui/portionItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Constants/colors.dart';
import '../Create_Portion/newPortion.dart';
import '../Full_Portion_view/fullPortionView.dart';

class FarmPortionsPage extends StatefulWidget {
  final Map<String, dynamic> field;

  const FarmPortionsPage({super.key, required this.field});

  @override
  State<FarmPortionsPage> createState() => _FarmPortionsPageState();
}

class _FarmPortionsPageState extends State<FarmPortionsPage> {
  // Sample initial data for demo purposes
  List<Map<String, dynamic>> _portions = [];
  bool _isLoading = false;
  String _searchQuery = '';

  Future<void> _addPortion(
      String portionName, String rowLength, String portionType) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Create portion data
      final portionData = {
        'name': portionName,
        'rowLength': rowLength,
        'portionType': portionType,
        'fieldId': widget.field['id'],
        'crop': '',
        'completedTasks': 0,
        'totalTasks': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add portion to user's cropFields/fieldId/portions collection
      final portionDocRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(widget.field['id'])
          .collection('portions')
          .add(portionData);

      // Update field document to include this portion ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(widget.field['id'])
          .update({
        'portions': FieldValue.arrayUnion([portionDocRef.id]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Add to local list
      setState(() {
        _portions.add({
          'id': portionDocRef.id,
          'portionName': portionName,
          'rowLength': rowLength,
          'portionType': portionType,
          'crop': '',
          'completedTasks': 0,
          'totalTasks': 0,
          'cropFaze': '',
          'dayCount': '',
          'rows': [],
        });
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$portionName added successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: MyColors().forestGreen,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding portion: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToCreatePortion() async {
    setState(() {
      _isLoading = true;
    });

    final newPortion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPortion()),
    );

    setState(() {
      _isLoading = false;
    });

    if (newPortion != null && mounted) {
      _addPortion(
        newPortion['portionName'],
        newPortion['rowLength'],
        newPortion['portionType'],
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newPortion['portionName']} added successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: MyColors().forestGreen,
        ),
      );
    }
  }

  void _navigateToPortionView(Map<String, dynamic> portion) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullPortionView(portionId: portion['id'])),
    );
  }

  void _deletePortion(int index) {
    final portionName = _portions[index]['portionName'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Portion',
          style: GoogleFonts.robotoSlab(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "$portionName"? This action cannot be undone.',
          style: GoogleFonts.roboto(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _portions.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$portionName deleted'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.roboto(),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get filteredPortions {
    if (_searchQuery.isEmpty) {
      return _portions;
    }

    return _portions
        .where((portion) =>
            portion['portionName']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            portion['portionType']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            portion['crop']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadPortions();
  }

  Future<void> _loadPortions() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Get portions for this field from user's collection
      final portionsQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(widget.field['id'])
          .collection('portions')
          .get();

      final List<Map<String, dynamic>> loadedPortions = [];
      for (var doc in portionsQuery.docs) {
        final data = doc.data();
        loadedPortions.add({
          'id': doc.id,
          'portionName': data['name'] ?? 'Unnamed Portion',
          'rowLength': data['rowLength'] ?? '0',
          'portionType': data['portionType'] ?? 'Unknown Type',
          'crop': data['crop'] ?? '',
          'completedTasks': data['completedTasks'] ?? 0,
          'totalTasks': data['totalTasks'] ?? 0,
          'cropFaze': data['cropFaze'] ?? '',
          'dayCount': data['dayCount'] ?? '',
          'rows': data['rows'] ?? [],
        });

        // For debugging
        print('Loaded portion: ${doc.id}');
        print('Rows data: ${data['rows']}');
      }

      setState(() {
        _portions = loadedPortions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading portions: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
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
            const FgwTopBar(title: 'Field Portions'),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
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
                    : Column(
                        children: [
                          // Search and stats
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Column(
                              children: [
                                // Search field
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search portions...',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: myColors.forestGreen),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Stats cards
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        '${_portions.length}',
                                        'Total Portions',
                                        myColors.forestGreen,
                                        Icons.grid_view_rounded,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildStatCard(
                                        _portions.isEmpty
                                            ? '0'
                                            : '${_portions.fold<int>(0, (sum, portion) => sum + (portion['completedTasks'] as int))}',
                                        'Completed Tasks',
                                        myColors.green,
                                        Icons.check_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Info card
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: myColors.lightGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: myColors.lightGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.objectGroup,
                                      color: myColors.forestGreen,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Field Portions',
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: myColors.forestGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  'Portions help you organize different areas of your field. Add portions to start tracking crops.',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Portions list
                          Expanded(
                            child: filteredPortions.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    padding: const EdgeInsets.all(20),
                                    itemCount: filteredPortions.length,
                                    itemBuilder: (context, index) {
                                      final portion = filteredPortions[index];
                                      return Dismissible(
                                        key: Key(portion['portionName']!),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.red[400],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          _deletePortion(index);
                                        },
                                        confirmDismiss: (direction) async {
                                          bool delete = false;
                                          await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                'Delete Portion',
                                                style: GoogleFonts.robotoSlab(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete "${portion['portionName']}"? This action cannot be undone.',
                                                style: GoogleFonts.roboto(),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    delete = true;
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Delete',
                                                    style: GoogleFonts.roboto(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          return delete;
                                        },
                                        child: GestureDetector(
                                          onTap: () =>
                                              _navigateToPortionView(portion),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16),
                                            child: PortionItem(
                                              portionName:
                                                  portion['portionName'],
                                              portionType:
                                                  portion['portionType'],
                                              portionId: portion['id'],
                                              crop: portion['crop'],
                                              cropFaze: portion['cropFaze'],
                                              dayCount: portion['dayCount'],
                                              rows: portion['rows'] != null
                                                  ? List<
                                                          Map<String,
                                                              dynamic>>.from(
                                                      portion['rows'])
                                                  : null,
                                            ),
                                          ).animate().fadeIn(
                                                duration: 400.ms,
                                                delay: 50.ms * index,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          // Add button at bottom
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, -2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _navigateToCreatePortion,
                                icon: const Icon(Icons.add),
                                label: const Text('Add New Portion'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColors.forestGreen,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.objectGroup,
            size: 64,
            color: Colors.grey[300],
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty ? 'No Portions Yet' : 'No Matching Results',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isEmpty
                ? 'Create portions to organize your field'
                : 'Try a different search term',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 32),
          if (_searchQuery.isEmpty)
            ElevatedButton.icon(
              onPressed: _navigateToCreatePortion,
              icon: const Icon(Icons.add),
              label: const Text('Add First Portion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors().forestGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        ],
      ),
    );
  }
}
