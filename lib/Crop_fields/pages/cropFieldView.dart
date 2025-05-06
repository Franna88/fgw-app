import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Crop_fields/pages/farmPortions/farmPortionsPage.dart';
import 'package:farming_gods_way/Inventory/inventory.dart';
import 'package:farming_gods_way/Production_Records/productionRecords.dart';
import 'package:farming_gods_way/Reminders/userReminders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CropFieldView extends StatefulWidget {
  final Map<String, dynamic> field;

  const CropFieldView({super.key, required this.field});

  @override
  State<CropFieldView> createState() => _CropFieldViewState();
}

class _CropFieldViewState extends State<CropFieldView> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();

    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            FgwTopBar(title: widget.field['name'] ?? 'Field Details'),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(widget.field['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms).scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.0, 1.0)),

                      const SizedBox(height: 24),

                      // Info section
                      Container(
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
                            Text(
                              'Field Information',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: myColors.forestGreen,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.straighten,
                              label: 'No Portions Added',
                              value: 'Add portions to get started',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              label: 'Created',
                              value: 'Today',
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                      const SizedBox(height: 24),

                      // Management section title
                      Text(
                        'Field Management',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                      const SizedBox(height: 16),

                      // Management options
                      _buildManagementCard(
                        icon: FontAwesomeIcons.objectGroup,
                        title: 'Portions',
                        description: 'Manage field portions',
                        color: myColors.forestGreen,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FarmPortionsPage(field: widget.field),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 300.ms)
                          .slideX(begin: -0.1, end: 0),

                      _buildManagementCard(
                        icon: FontAwesomeIcons.bell,
                        title: 'Reminders',
                        description: 'Set and manage reminders',
                        color: myColors.yellow,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserReminders(),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 400.ms)
                          .slideX(begin: -0.1, end: 0),

                      _buildManagementCard(
                        icon: FontAwesomeIcons.chartLine,
                        title: 'Production Records',
                        description: 'Track your production',
                        color: myColors.brightRed,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductionRecords(),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 500.ms)
                          .slideX(begin: -0.1, end: 0),

                      _buildManagementCard(
                        icon: FontAwesomeIcons.boxesStacked,
                        title: 'Inventory',
                        description: 'Manage your inventory',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Inventory(),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 600.ms)
                          .slideX(begin: -0.1, end: 0),

                      const SizedBox(height: 24),

                      // Settings button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Field settings logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Field settings coming soon'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                          label: const Text('Field Settings'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColors.yellow,
                            foregroundColor: myColors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManagementCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
