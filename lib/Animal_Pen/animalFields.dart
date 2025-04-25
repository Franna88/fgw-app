import 'package:farming_gods_way/Animal_Pen/newAnimalField.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalFieldView.dart';
import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';
import '../Crop_fields/pages/createNewField.dart';
import '../Crop_fields/ui/fieldListItem.dart';

class AnimalFields extends StatefulWidget {
  const AnimalFields({super.key});

  @override
  State<AnimalFields> createState() => _AnimalFieldsState();
}

class _AnimalFieldsState extends State<AnimalFields> with SingleTickerProviderStateMixin {
  List<Map<String, String>> fields = [];
  List<Map<String, String>> filteredFields = [];
  bool _isLoading = true;
  bool _isSearching = false;
  late AnimationController _fabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _fabController.forward();
      }
    });

    _searchController.addListener(_filterFields);
  }
  
  @override
  void dispose() {
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterFields() {
    if (_searchController.text.isEmpty) {
      setState(() {
        filteredFields = List.from(fields);
      });
      return;
    }

    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFields = fields.where((field) {
        final name = field['name']?.toLowerCase() ?? '';
        final animal = field['animal']?.toLowerCase() ?? '';
        return name.contains(query) || animal.contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        filteredFields = List.from(fields);
      }
    });
  }

  void _navigateToCreateField() async {
    final newField = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAnimalField()),
    );

    if (newField != null && mounted) {
      setState(() {
        fields.add(Map<String, String>.from(newField));
        filteredFields = List.from(fields);
      });
    }
  }

  void _navigateToFieldView(Map<String, String> field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalFieldView(field: field),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            const FgwTopBar(title: 'Animal Pens'),
            const SizedBox(height: 16),
            
            // Search and action area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _isSearching 
                ? _buildSearchField(myColors)
                : _buildActionButtons(myColors),
            ),
            
            const SizedBox(height: 20),
            
            // Content area
            Expanded(
              child: Container(
                width: double.infinity,
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
                    : fields.isEmpty
                        ? _buildEmptyState()
                        : _buildFieldsList(myColors),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: fields.isNotEmpty 
        ? ScaleTransition(
            scale: _fabController,
            child: FloatingActionButton(
              backgroundColor: myColors.lightGreen,
              foregroundColor: Colors.white,
              elevation: 4,
              onPressed: _navigateToCreateField,
              child: const Icon(Icons.add),
            ),
          )
        : null,
    );
  }

  Widget _buildSearchField(MyColors myColors) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search animal pens...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              style: GoogleFonts.roboto(),
              autofocus: true,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _toggleSearch,
            color: Colors.grey[600],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).moveX(begin: 20, end: 0);
  }

  Widget _buildActionButtons(MyColors myColors) {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            customHeight: 50,
            customWidth: double.infinity,
            buttonText: 'Add Animal Pen',
            textColor: myColors.black,
            buttonColor: myColors.yellow,
            onTap: _navigateToCreateField,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: myColors.offWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: myColors.black,
            ),
            onPressed: _toggleSearch,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: myColors.offWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
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
                  content: Text('Filter options coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFieldsList(MyColors myColors) {
    final displayFields = _isSearching ? filteredFields : fields;
    
    if (_isSearching && filteredFields.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayFields.length,
      itemBuilder: (context, index) {
        final field = displayFields[index];
        
        // Get the appropriate icon based on animal type
        IconData animalIcon;
        switch (field['animal']) {
          case 'Sheep':
            animalIcon = FontAwesomeIcons.pagelines;
            break;
          case 'Cattle':
            animalIcon = FontAwesomeIcons.horse;
            break;
          case 'Pigs':
            animalIcon = FontAwesomeIcons.piggyBank;
            break;
          case 'Chickens':
            animalIcon = FontAwesomeIcons.dove;
            break;
          default:
            animalIcon = FontAwesomeIcons.paw;
        }
        
        // Create the widget then animate it
        Widget card = ModernCard(
          onTap: () => _navigateToFieldView(field),
          child: Row(
            children: [
              // Animal pen image or icon
              Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: myColors.forestGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(field['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: myColors.forestGreen,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: FaIcon(
                        animalIcon,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Field details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field['name']!,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: myColors.lightGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                animalIcon,
                                size: 12,
                                color: myColors.forestGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                field['animal']!,
                                style: GoogleFonts.roboto(
                                  color: myColors.forestGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• Tap to manage',
                          style: GoogleFonts.roboto(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
        
        // Apply animation to the card
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: card.animate()
            .fadeIn(duration: 400.ms, delay: 50.ms * index.toDouble())
            .moveY(begin: 20, end: 0, curve: Curves.easeOutQuad),
        );
      },
    );
  }
  
  Widget _buildEmptyState() {
    final myColors = MyColors();
    
    // Create the content then animate it
    Widget content = Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: myColors.lightGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.cow,
                size: 64,
                color: myColors.forestGreen.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Animal Pens Yet',
            style: GoogleFonts.robotoSlab(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add your first animal pen to start managing your livestock effectively',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _navigateToCreateField,
            icon: const Icon(Icons.add),
            label: Text(
              'Add First Animal Pen',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.forestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
    
    // Apply animation and return
    return Center(
      child: content.animate()
        .fadeIn(duration: 600.ms)
        .moveY(begin: 10, end: 0, duration: 600.ms, curve: Curves.easeOutQuad),
    );
  }
}
