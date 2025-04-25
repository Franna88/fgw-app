import 'package:farming_gods_way/Farmers_guide/Pages/farmItemGuide.dart';
import 'package:farming_gods_way/Farmers_guide/ui/categoryGuideItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class CategoryViewPage extends StatefulWidget {
  final String category;
  
  const CategoryViewPage({
    super.key, 
    required this.category,
  });

  @override
  State<CategoryViewPage> createState() => _CategoryViewPageState();
}

class _CategoryViewPageState extends State<CategoryViewPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  
  @override
  void initState() {
    super.initState();
    _loadItems();
    
    _searchController.addListener(() {
      _filterItems(_searchController.text);
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _loadItems() {
    // Dynamically load items based on category
    switch(widget.category.toLowerCase()) {
      case 'crops':
        _items = [
          {'name': 'Tomatoes', 'image': 'images/tomatos.png'},
          {'name': 'Potatoes', 'image': 'images/potatoes.png'},
          {'name': 'Corn', 'image': 'images/corn.png'},
          {'name': 'Beetroot', 'image': 'images/beetroot.png'},
          {'name': 'Spinach', 'image': 'images/spinach2.png'},
          {'name': 'Carrot', 'image': 'images/carrots.png'},
        ];
        break;
      case 'livestock':
        _items = [
          {'name': 'Cattle', 'image': 'images/cows.png'},
          {'name': 'Goats', 'image': 'images/goats.png'},
          {'name': 'Chickens', 'image': 'images/chickens.png'},
        ];
        break;
      case 'pest control':
        _items = [
          {'name': 'Aphids', 'image': 'images/aphids.png'},
          {'name': 'Beetles', 'image': 'images/beetles.png'},
          {'name': 'Fungus', 'image': 'images/fungus.png'},
        ];
        break;
      case 'soil management':
        _items = [
          {'name': 'Composting', 'image': 'images/compost.png'},
          {'name': 'Mulching', 'image': 'images/mulch.png'},
          {'name': 'Crop Rotation', 'image': 'images/rotation.png'},
        ];
        break;
      default:
        _items = [];
    }
    
    _filteredItems = List.from(_items);
    setState(() {});
  }
  
  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = List.from(_items);
      });
      return;
    }
    
    setState(() {
      _filteredItems = _items
          .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
          ),
          child: Column(
            children: [
              FgwTopBar(),
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: widget.category,
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search ${widget.category}',
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 22),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  width: MyUtility(context).width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: _filteredItems.isEmpty 
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available ${widget.category}',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: myColors.forestGreen,
                                ),
                              ).animate().fadeIn(delay: 200.ms),
                              const SizedBox(height: 15),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredItems[index];
                                  return CategoryGuideItem(
                                    image: item['image'],
                                    name: item['name'],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FarmItemGuide(
                                                  category: widget.category,
                                                  itemName: item['name'],
                                                  imagePath: item['image'],
                                                )),
                                      );
                                    },
                                  ).animate().fadeIn(
                                    delay: Duration(milliseconds: 200 + (100 * index)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
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
            FontAwesomeIcons.magnifyingGlass,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No items found',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try searching with different keywords',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear search'),
            style: TextButton.styleFrom(
              foregroundColor: MyColors().forestGreen,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
