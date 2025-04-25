import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController nameController = TextEditingController(text: 'Farmer John');
  final TextEditingController emailController = TextEditingController(text: 'john.farmer@example.com');
  final TextEditingController phoneController = TextEditingController(text: '082 123 4567');
  final TextEditingController addressController = TextEditingController(text: '123 Farm Road, Pretoria');
  
  bool isEditingMode = false;
  String profileImagePath = 'images/userImage.png';
  
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
        {'title': 'Farm Type', 'value': 'Mixed Farm'},
        {'title': 'Farm Size', 'value': '12.5 Hectares'},
        {'title': 'Farm Location', 'value': 'Pretoria, South Africa'},
      ]
    },
    {
      'title': 'Account Settings',
      'icon': Icons.settings_outlined,
      'items': [
        {'title': 'Change Password', 'action': 'password'},
        {'title': 'Notification Preferences', 'action': 'notifications'},
        {'title': 'Delete Account', 'action': 'delete', 'color': Colors.red},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                              isEditingMode ? Icons.check : Icons.edit, 
                              color: Colors.white
                            ),
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
                        onTap: isEditingMode ? _changeProfileImage : null,
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
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(profileImagePath),
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
                                        color: Colors.black.withOpacity(0.2),
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
                        "Small Scale Farmer",
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
                      ...settingsSections.map((section) {
                        return _buildSettingsSection(
                          title: section['title'],
                          icon: section['icon'],
                          items: section['items'],
                        );
                      }).toList(),
                      
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
  
  void _changeProfileImage() {
    // In a real app, this would open an image picker
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
                    // This would use camera
                    Navigator.pop(context);
                    _showImageChangedSnackbar();
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    // This would open gallery
                    Navigator.pop(context);
                    _showImageChangedSnackbar();
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.delete,
                  label: "Remove",
                  onTap: () {
                    // This would remove current image
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile picture removed'),
                        backgroundColor: MyColors().forestGreen,
                      ),
                    );
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
  
  void _handleSettingAction(String action) {
    switch (action) {
      case 'password':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Change Password functionality will be implemented soon'),
            backgroundColor: MyColors().forestGreen,
          ),
        );
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
      default:
        break;
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion is not implemented in this demo'),
                  backgroundColor: Colors.red,
                ),
              );
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
  
  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: MyColors().forestGreen,
      ),
    );
  }
  
  void _showImageChangedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile picture updated'),
        backgroundColor: MyColors().forestGreen,
      ),
    );
  }
} 