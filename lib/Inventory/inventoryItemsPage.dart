import 'package:farming_gods_way/Inventory/ui/inventoryItems.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';
import 'models/inventory_item.dart';
import 'services/inventory_service.dart';
import 'ui/add_inventory_item.dart';

class InventoryItemsPage extends StatefulWidget {
  final String category;
  
  const InventoryItemsPage({
    super.key,
    required this.category,
  });

  @override
  State<InventoryItemsPage> createState() => _InventoryItemsPageState();
}

class _InventoryItemsPageState extends State<InventoryItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  final InventoryService _inventoryService = InventoryService();
  List<InventoryItem> _items = [];
  List<InventoryItem> _filteredItems = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final items = await _inventoryService.getItemsByCategory(widget.category);
      setState(() {
        _items = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading items: $e');
      // Create fallback items when loading fails
      final fallbackItems = [
        InventoryItem(
          id: '1',
          name: 'Sample ${widget.category}',
          category: widget.category,
          imageUrl: 'images/${widget.category.toLowerCase()}.png',
          quantity: 10,
          unit: 'kg',
          dateAdded: DateTime.now(),
          notes: 'Fallback item (data will be saved once SharedPreferences is working)',
        ),
      ];
      
      setState(() {
        _items = fallbackItems;
        _filteredItems = fallbackItems;
        _isLoading = false;
      });
      
      if (!mounted) return;
      
      // Show a non-error snackbar as guidance
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Using example data. Your changes will be visible but may not persist until you restart the app.',
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _items;
      });
      return;
    }
    
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        return item.name.toLowerCase().contains(lowercaseQuery) ||
               (item.notes?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    });
  }
  
  Future<void> _updateItemQuantity(String itemId, int newQuantity) async {
    try {
      final updatedItem = await _inventoryService.updateItemQuantity(itemId, newQuantity);
      if (updatedItem != null) {
        // Refresh just the item that changed
        setState(() {
          final index = _items.indexWhere((item) => item.id == itemId);
          if (index != -1) {
            _items[index] = updatedItem;
            
            // Also update filtered items if needed
            final filteredIndex = _filteredItems.indexWhere((item) => item.id == itemId);
            if (filteredIndex != -1) {
              _filteredItems[filteredIndex] = updatedItem;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      // Update local state even if SharedPreferences fails
      setState(() {
        final index = _items.indexWhere((item) => item.id == itemId);
        if (index != -1) {
          _items[index].quantity = newQuantity;
          
          // Also update filtered items if needed
          final filteredIndex = _filteredItems.indexWhere((item) => item.id == itemId);
          if (filteredIndex != -1) {
            _filteredItems[filteredIndex].quantity = newQuantity;
          }
        }
      });
    }
  }
  
  Future<void> _addNewItem() async {
    try {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => AddInventoryItem(category: widget.category),
        ),
      );
      
      if (result == true) {
        _loadItems(); // Refresh the list
      }
    } catch (e) {
      debugPrint('Error navigating to add item screen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open add item screen. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MyUtility(context).height,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60),
            ),
          ),
          child: Column(
            children: [
              const FgwTopBar(),
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: widget.category,
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterItems,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Search ${widget.category.toLowerCase()}',
                        hintStyle: GoogleFonts.roboto(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: myColors.forestGreen,
                          size: 20,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredItems.isEmpty
                        ? _buildEmptyState(myColors)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                              children: [
                                _buildInventoryHeader(myColors),
                                ..._filteredItems.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  
                                  return InventoryItems(
                                    image: item.imageUrl,
                                    name: item.name,
                                    count: item.quantity,
                                    unit: item.unit,
                                    notes: item.notes,
                                    onChanged: (newCount) => 
                                        _updateItemQuantity(item.id, newCount),
                                  ).animate().fadeIn(
                                      duration: 300.ms, 
                                      delay: Duration(milliseconds: 50 * index),
                                  );
                                }).toList(),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.yellow,
        foregroundColor: myColors.black,
        child: const Icon(Icons.add),
        onPressed: _addNewItem,
      ),
    );
  }
  
  Widget _buildEmptyState(MyColors myColors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No items yet',
              style: GoogleFonts.robotoSlab(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first ${widget.category.toLowerCase()} item by clicking the + button',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInventoryHeader(MyColors myColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: myColors.forestGreen.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: myColors.forestGreen.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.clipboard,
            color: myColors.forestGreen,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            'Current Stock',
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: myColors.forestGreen,
            ),
          ),
          const Spacer(),
          Text(
            '${_filteredItems.length} items',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: myColors.forestGreen.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
