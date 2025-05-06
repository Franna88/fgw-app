import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:farming_gods_way/Crop_fields/ui/fieldListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';
import 'pages/createNewField.dart';
import 'pages/cropFieldView.dart';

class CropFields extends StatefulWidget {
  const CropFields({super.key});

  @override
  State<CropFields> createState() => _CropFieldsState();
}

class _CropFieldsState extends State<CropFields>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> fields = [];
  bool _isLoading = true;
  String? _error;
  late AnimationController _fabController;

  // Sample field images for demonstration
  final List<String> _fieldImages = [
    'images/cropField.png',
    'images/cropField.png',
    'images/cropField.png',
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadFields();
  }

  Future<void> _loadFields() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() {
          _error = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      // Get fields directly from the user's collection
      final fieldsQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .get();

      final List<Map<String, dynamic>> loadedFields = [];
      for (var doc in fieldsQuery.docs) {
        final data = doc.data();
        loadedFields.add({
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed Field',
          'imageUrl': data['imageUrl'] ?? 'images/cropField.png',
          'userId': currentUser.uid, // Add user ID to each field
          'portions': data['portions'] ?? [],
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
        });
      }

      setState(() {
        fields = loadedFields;
        _isLoading = false;
        _error = null;
      });
      _fabController.forward();
    } catch (e) {
      setState(() {
        _error = 'Error loading fields: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _navigateToCreateField() async {
    final newField = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNewField()),
    );

    if (newField != null && mounted) {
      setState(() {
        fields.insert(
            0, newField); // Add new field at the beginning of the list
      });
      await _loadFields(); // Still reload to ensure data consistency
    }
  }

  void _navigateToFieldView(Map<String, dynamic> field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropFieldView(field: field),
      ),
    ).then((result) {
      if (result != null && result['updated'] == true && mounted) {
        _loadFields(); // Reload fields after updates
      }
    });
  }

  Future<void> _deleteField(Map<String, dynamic> field) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Delete field image from storage if it's not the default image
      if (field['imageUrl'] != 'images/cropField.png') {
        final ref = FirebaseStorage.instance.refFromURL(field['imageUrl']);
        await ref.delete();
      }

      // Delete field document from user's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cropFields')
          .doc(field['id'])
          .delete();

      if (mounted) {
        await _loadFields(); // Reload fields after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${field['name']} deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting field: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final myUtility = MyUtility(context);

    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            const FgwTopBar(title: 'Crop Fields'),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToCreateField,
                      icon: Icon(Icons.add, color: myColors.black),
                      label: Text(
                        'Add Field',
                        style: TextStyle(color: myColors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myColors.yellow,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: myColors.offWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: myColors.black,
                      ),
                      onPressed: () {
                        // Filter functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Filter options coming soon')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content area
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
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _error!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadFields,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : fields.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.tractor,
                                      size: 64,
                                      color:
                                          myColors.forestGreen.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No fields found',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Create your first field to get started',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: fields.length,
                                itemBuilder: (context, index) {
                                  final field = fields[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: ModernCard(
                                      onTap: () => _navigateToFieldView(field),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: myColors.lightGreen
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: field['imageUrl']
                                                            .startsWith('http')
                                                        ? NetworkImage(
                                                            field['imageUrl'])
                                                        : AssetImage(field[
                                                                'imageUrl'])
                                                            as ImageProvider,
                                                    fit: BoxFit.cover,
                                                    onError: (exception,
                                                        stackTrace) {
                                                      // Handle image loading error
                                                      debugPrint(
                                                          'Error loading image: $exception');
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      field['name'],
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${field['portions'].length} portions',
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.delete_outline),
                                                color: Colors.red,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Delete Field'),
                                                      content: Text(
                                                          'Are you sure you want to delete "${field['name']}"?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            _deleteField(field);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                            foregroundColor:
                                                                Colors.white,
                                                          ),
                                                          child: const Text(
                                                              'Delete'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateField,
        backgroundColor: myColors.forestGreen,
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      ).animate(controller: _fabController).scale(),
    );
  }
}
