import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../services/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isEditingMode = false;
  String profileImagePath = 'images/userImage.png';
  String? profileImageUrl;

  bool _isLoading = true;
  String? _error;

  // User and farm data
  Map<String, dynamic> userData = {};
  Map<String, dynamic> farmData = {};
  String userType =
      'farmer'; // Default to farmer, will be updated when data is loaded

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get current user ID
      final String? userId = FirebaseService.currentUser?.uid;

      if (userId != null) {
        // Fetch user data
        final DocumentSnapshot userDoc = await FirebaseService.firestore
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          userData = userDoc.data() as Map<String, dynamic>;

          // Set user type
          userType = userData['userType'] ?? 'farmer';

          // Set controller values
          nameController.text =
              '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}';
          emailController.text = userData['email'] ?? '';
          phoneController.text = userData['phoneNumber'] ?? '';
          addressController.text = userData['homeAddress'] ?? '';

          // Set profile image if available
          if (userData['profileImageUrl'] != null) {
            profileImageUrl = userData['profileImageUrl'];
          }

          // If user is a farmer, fetch farm data
          if (userType == 'farmer' &&
              userData['farms'] != null &&
              (userData['farms'] as List).isNotEmpty) {
            final String farmId = (userData['farms'] as List)[0];
            final DocumentSnapshot farmDoc = await FirebaseService.firestore
                .collection('farms')
                .doc(farmId)
                .get();

            if (farmDoc.exists) {
              farmData = farmDoc.data() as Map<String, dynamic>;
            }
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error loading profile: $e';
      });
    }
  }

  final List<Map<String, dynamic>> settingsSections = [
    {
      'title': 'Personal Information',
      'icon': Icons.person_outline,
      'items': [
        {'title': 'Full Name', 'field': 'name'},
        {'title': 'Email Address', 'field': 'email'},
        {'title': 'Phone Number', 'field': 'phone'},
        {'title': 'Address', 'field': 'address'},
      ]
    },
    {
      'title': 'Farm Information',
      'icon': FontAwesomeIcons.tractor,
      'items': [
        {'title': 'Farm Name', 'field': 'farmName'},
        {'title': 'Farm Type', 'field': 'farmType'},
        {'title': 'Location', 'field': 'location'},
        {'title': 'Production Type', 'field': 'productionType'},
        {'title': 'Soil Type', 'field': 'soilType'},
        {'title': 'Water Source', 'field': 'waterSource'},
      ]
    },
    {
      'title': 'Account Settings',
      'icon': Icons.settings_outlined,
      'items': [
        {'title': 'Change Password', 'action': 'password'},
        {'title': 'Notification Preferences', 'action': 'notifications'},
        {'title': 'Delete Account', 'action': 'delete', 'color': Colors.red},
        {'title': 'Sign Out', 'action': 'signout', 'color': Colors.orange},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors().forestGreen,
              ),
            )
          : _error != null
              ? _buildErrorView()
              : Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.03,
                        child: Image.asset(
                          'images/loginImg.png',
                          repeat: ImageRepeat.repeat,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Main content
                    SafeArea(
                      child: Column(
                        children: [
                          // Header section
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                            decoration: BoxDecoration(
                              color: MyColors().forestGreen,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.white),
                                      onPressed: () => Navigator.pop(context),
                                    ).animate().fadeIn(duration: 300.ms),
                                    Text(
                                      "Profile Settings",
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                          isEditingMode
                                              ? Icons.check
                                              : Icons.edit,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          isEditingMode = !isEditingMode;
                                          if (!isEditingMode) {
                                            // Save the changes when exiting edit mode
                                            _saveChanges();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Profile image section
                                GestureDetector(
                                  onTap: isEditingMode
                                      ? _changeProfileImage
                                      : null,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: profileImageUrl != null
                                                ? NetworkImage(profileImageUrl!)
                                                    as ImageProvider
                                                : AssetImage(profileImagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      if (isEditingMode)
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 16,
                                              color: MyColors().forestGreen,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 600.ms),
                                const SizedBox(height: 10),
                                Text(
                                  nameController.text,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  userType == 'farmer' ? "Farmer" : "Worker",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Settings sections
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(20),
                              children: [
                                // Personal Information section
                                _buildSettingsSection(
                                  title: settingsSections[0]['title'],
                                  icon: settingsSections[0]['icon'],
                                  items: settingsSections[0]['items'],
                                ),

                                // Farm Information section - only show for farmers
                                if (userType == 'farmer')
                                  _buildFarmSettingsSection(),

                                // Account Settings section
                                _buildSettingsSection(
                                  title: settingsSections[2]['title'],
                                  icon: settingsSections[2]['icon'],
                                  items: settingsSections[2]['items'],
                                ),

                                // Version info
                                const SizedBox(height: 30),
                                Center(
                                  child: Text(
                                    "App Version 1.0.0",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Profile',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserData,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors().forestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmSettingsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.tractor,
                  size: 18,
                  color: MyColors().forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  'Farm Information',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Farm items
          _buildNonEditableSettingItem(
            title: 'Farm Name',
            value: farmData['farmName'] ?? 'Not specified',
          ),
          _buildNonEditableSettingItem(
            title: 'Farm Type',
            value: farmData['farmType'] ?? 'Not specified',
          ),
          _buildNonEditableSettingItem(
            title: 'Location',
            value: farmData['location'] ?? 'Not specified',
          ),
          _buildNonEditableSettingItem(
            title: 'Address',
            value: farmData['address'] ?? 'Not specified',
          ),
          _buildNonEditableSettingItem(
            title: 'Production Type',
            value: farmData['productionType'] ?? 'Not specified',
          ),
          _buildNonEditableSettingItem(
            title: 'Soil Type',
            value: farmData['soilType'] ?? 'Not specified',
          ),
          _buildNonEditableSettingItem(
            title: 'Water Source',
            value: farmData['waterSource'] ?? 'Not specified',
          ),
          if (farmData['coordinates'] != null)
            _buildNonEditableSettingItem(
              title: 'Coordinates',
              value: '${farmData['latitude']}° S, ${farmData['longitude']}° E',
            ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: MyColors().forestGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Section items
          ...items.map((item) {
            if (item.containsKey('field')) {
              return _buildEditableSettingItem(
                title: item['title'],
                field: item['field'],
              );
            } else if (item.containsKey('action')) {
              return _buildActionSettingItem(
                title: item['title'],
                action: item['action'],
                color: item['color'],
              );
            } else {
              return _buildNonEditableSettingItem(
                title: item['title'],
                value: item['value'],
              );
            }
          }).toList(),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEditableSettingItem({
    required String title,
    required String field,
  }) {
    TextEditingController? controller;
    String? value;

    // Assign the correct controller based on field
    switch (field) {
      case 'name':
        controller = nameController;
        break;
      case 'email':
        controller = emailController;
        break;
      case 'phone':
        controller = phoneController;
        break;
      case 'address':
        controller = addressController;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          if (isEditingMode)
            TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: MyColors().forestGreen),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            )
          else
            Text(
              controller?.text ?? '',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNonEditableSettingItem({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSettingItem({
    required String title,
    required String action,
    Color? color,
  }) {
    return InkWell(
      onTap: () => _handleSettingAction(action),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: color ?? Colors.black87,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeProfileImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Change Profile Photo",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    _getImageFromSource(ImageSource.camera);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _getImageFromSource(ImageSource.gallery);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.delete,
                  label: "Remove",
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfileImage();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _isLoading = true;
        });

        // Upload image to Firebase Storage
        final File imageFile = File(image.path);
        final userId = FirebaseService.currentUser!.uid;

        final Reference ref = FirebaseService.storage.ref().child(
            'users/$userId/profile_${DateTime.now().millisecondsSinceEpoch}');

        final UploadTask uploadTask = ref.putFile(imageFile);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update profile image URL in Firestore
        await FirebaseService.firestore.collection('users').doc(userId).update({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          profileImageUrl = downloadUrl;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: MyColors().forestGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeProfileImage() async {
    try {
      if (profileImageUrl != null) {
        setState(() {
          _isLoading = true;
        });

        final userId = FirebaseService.currentUser!.uid;

        // Update profile in Firestore
        await FirebaseService.firestore.collection('users').doc(userId).update({
          'profileImageUrl': FieldValue.delete(),
        });

        setState(() {
          profileImageUrl = null;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture removed'),
            backgroundColor: MyColors().forestGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing profile picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: MyColors().forestGreen,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSettingAction(String action) async {
    switch (action) {
      case 'password':
        _showChangePasswordDialog();
        break;
      case 'notifications':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification Preferences will be implemented soon'),
            backgroundColor: MyColors().forestGreen,
          ),
        );
        break;
      case 'delete':
        _showDeleteAccountDialog();
        break;
      case 'signout':
        _signOut();
        break;
      default:
        break;
    }
  }

  Future<void> _signOut() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseService.signOut();

      setState(() {
        _isLoading = false;
      });

      // Navigate to login screen
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Change Password",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _changePassword(
                  currentPassword: currentPasswordController.text,
                  newPassword: newPasswordController.text,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors().forestGreen,
              foregroundColor: Colors.white,
            ),
            child: Text("CHANGE"),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get current user
      final user = FirebaseService.currentUser;
      if (user == null) {
        throw Exception('No user is signed in');
      }

      // Create credentials with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Reauthenticate user
      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: MyColors().forestGreen,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Failed to change password: $e';
      if (e.toString().contains('wrong-password')) {
        errorMessage = 'Current password is incorrect';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Account",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "CANCEL",
              style: GoogleFonts.roboto(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              "DELETE",
              style: GoogleFonts.roboto(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = FirebaseService.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await FirebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .delete();

        // If user is a farmer, delete farm data
        if (userType == 'farmer' && userData['farms'] != null) {
          for (final farmId in userData['farms']) {
            await FirebaseService.firestore
                .collection('farms')
                .doc(farmId)
                .delete();
          }
        }

        // Delete user authentication account
        await user.delete();

        setState(() {
          _isLoading = false;
        });

        // Navigate to login screen
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error deleting account: $e\nYou may need to reauthenticate before deleting your account.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userId = FirebaseService.currentUser!.uid;

      // Parse name into first and last name
      final fullName = nameController.text.trim();
      final nameParts = fullName.split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Update user data in Firestore
      await FirebaseService.firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'email':
            emailController.text.trim(), // Note: This won't change auth email
        'phoneNumber': phoneController.text.trim(),
        'homeAddress': addressController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: MyColors().forestGreen,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
