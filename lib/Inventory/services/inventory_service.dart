import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/inventory_item.dart';

class InventoryService {
  static const String _storageKey = 'inventory_items';
  static const Uuid _uuid = Uuid();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Use secure storage as fallback
  Future<void> _saveToSecureStorage(List<String> items) async {
    try {
      await _secureStorage.write(
        key: _storageKey,
        value: jsonEncode(items),
      );
    } catch (e) {
      debugPrint('Error saving to secure storage: $e');
    }
  }
  
  Future<List<String>> _getFromSecureStorage() async {
    try {
      final data = await _secureStorage.read(key: _storageKey);
      if (data != null) {
        final List<dynamic> items = jsonDecode(data);
        return items.cast<String>();
      }
    } catch (e) {
      debugPrint('Error reading from secure storage: $e');
    }
    return [];
  }
  
  // Initialize and get dummy data for testing without relying on SharedPreferences
  Future<List<InventoryItem>> getAllItems() async {
    try {
      // Try SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getStringList(_storageKey);
      
      if (itemsJson != null && itemsJson.isNotEmpty) {
        return itemsJson
            .map((item) => InventoryItem.fromMap(jsonDecode(item)))
            .toList();
      }
      
      // Try secure storage as fallback
      final secureItems = await _getFromSecureStorage();
      if (secureItems.isNotEmpty) {
        return secureItems
            .map((item) => InventoryItem.fromMap(jsonDecode(item)))
            .toList();
      }
      
      // If no data in either storage, return dummy items
      return _getDummyItems();
    } catch (e) {
      debugPrint('Error getting items: $e');
      // Return dummy data if both storage options fail
      return _getDummyItems();
    }
  }
  
  // Get dummy items for testing
  List<InventoryItem> _getDummyItems() {
    return [
      InventoryItem(
        id: '1',
        name: 'Potatoes',
        category: 'Crops',
        imageUrl: 'images/potatoes.png',
        quantity: 50,
        unit: 'kg',
        dateAdded: DateTime.now(),
        notes: 'Fresh harvest',
      ),
      InventoryItem(
        id: '2',
        name: 'Beetroot',
        category: 'Crops',
        imageUrl: 'images/beetroot.png',
        quantity: 30,
        unit: 'kg',
        dateAdded: DateTime.now(),
        notes: 'Stored in cool place',
      ),
    ];
  }
  
  // Get items by category
  Future<List<InventoryItem>> getItemsByCategory(String category) async {
    try {
      final items = await getAllItems();
      return items.where((item) => item.category == category).toList();
    } catch (e) {
      debugPrint('Error getting items by category: $e');
      // Return filtered dummy data for the category
      return _getDummyItems()
          .where((item) => item.category == category)
          .toList();
    }
  }
  
  // Add a new item with secure storage fallback
  Future<InventoryItem> addItem({
    required String name,
    required String category,
    required String imageUrl,
    required int quantity,
    required String unit,
    double? unitCost,
    String? notes,
  }) async {
    final item = InventoryItem(
      id: _uuid.v4(),
      name: name,
      category: category,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      dateAdded: DateTime.now(),
      lastUpdated: DateTime.now(),
      unitCost: unitCost,
      notes: notes,
    );
    
    try {
      // Try SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getStringList(_storageKey) ?? [];
      
      final encodedItem = jsonEncode(item.toMap());
      itemsJson.add(encodedItem);
      
      final success = await prefs.setStringList(_storageKey, itemsJson);
      
      if (!success) {
        // If SharedPreferences fails, try secure storage
        await _saveToSecureStorage(itemsJson);
      }
      
      return item;
    } catch (e) {
      debugPrint('Error adding item: $e');
      
      try {
        // Try secure storage as fallback
        final items = await _getFromSecureStorage();
        items.add(jsonEncode(item.toMap()));
        await _saveToSecureStorage(items);
      } catch (e) {
        debugPrint('Error adding item to secure storage: $e');
      }
      
      return item;
    }
  }
  
  // Update an existing item
  Future<InventoryItem?> updateItem(InventoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getStringList(_storageKey) ?? [];
    
    final items = itemsJson
        .map((itemStr) => InventoryItem.fromMap(jsonDecode(itemStr)))
        .toList();
    
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return null;
    
    item.lastUpdated = DateTime.now();
    items[index] = item;
    
    final updatedItemsJson = items
        .map((item) => jsonEncode(item.toMap()))
        .toList();
    
    await prefs.setStringList(_storageKey, updatedItemsJson);
    return item;
  }
  
  // Update item quantity with secure storage fallback
  Future<InventoryItem?> updateItemQuantity(String itemId, int newQuantity) async {
    try {
      // Try to get items from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> itemsJson = prefs.getStringList(_storageKey) ?? [];
      
      if (itemsJson.isEmpty) {
        // If SharedPreferences is empty, try secure storage
        itemsJson = await _getFromSecureStorage();
      }
      
      // Parse items and update the quantity
      final items = itemsJson
          .map((itemStr) => InventoryItem.fromMap(jsonDecode(itemStr)))
          .toList();
      
      final index = items.indexWhere((i) => i.id == itemId);
      if (index == -1) return null;
      
      items[index].updateQuantity(newQuantity);
      
      // Convert back to JSON
      final updatedItemsJson = items
          .map((item) => jsonEncode(item.toMap()))
          .toList();
      
      // Try to save to SharedPreferences
      final success = await prefs.setStringList(_storageKey, updatedItemsJson);
      
      if (!success) {
        // If SharedPreferences fails, save to secure storage
        await _saveToSecureStorage(updatedItemsJson);
      }
      
      return items[index];
    } catch (e) {
      debugPrint('Error updating item quantity: $e');
      
      try {
        // Try secure storage as fallback
        final itemsJson = await _getFromSecureStorage();
        
        final items = itemsJson
            .map((itemStr) => InventoryItem.fromMap(jsonDecode(itemStr)))
            .toList();
        
        final index = items.indexWhere((i) => i.id == itemId);
        if (index == -1) return null;
        
        items[index].updateQuantity(newQuantity);
        
        final updatedItemsJson = items
            .map((item) => jsonEncode(item.toMap()))
            .toList();
        
        await _saveToSecureStorage(updatedItemsJson);
        
        return items[index];
      } catch (e) {
        debugPrint('Error updating item in secure storage: $e');
        // Find item in dummy data and update it (for demo purposes)
        final dummyItems = _getDummyItems();
        final index = dummyItems.indexWhere((i) => i.id == itemId);
        if (index != -1) {
          dummyItems[index].updateQuantity(newQuantity);
          return dummyItems[index];
        }
      }
      
      return null;
    }
  }
  
  // Delete an item
  Future<bool> deleteItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getStringList(_storageKey) ?? [];
    
    final items = itemsJson
        .map((itemStr) => InventoryItem.fromMap(jsonDecode(itemStr)))
        .toList();
    
    final initialLength = items.length;
    items.removeWhere((item) => item.id == itemId);
    
    if (items.length == initialLength) return false;
    
    final updatedItemsJson = items
        .map((item) => jsonEncode(item.toMap()))
        .toList();
    
    await prefs.setStringList(_storageKey, updatedItemsJson);
    return true;
  }
  
  // Get inventory categories
  Future<List<String>> getCategories() async {
    final items = await getAllItems();
    return items
        .map((item) => item.category)
        .toSet()
        .toList();
  }
  
  // Search inventory items
  Future<List<InventoryItem>> searchItems(String query) async {
    final items = await getAllItems();
    query = query.toLowerCase();
    
    return items.where((item) {
      return item.name.toLowerCase().contains(query) ||
             item.category.toLowerCase().contains(query) ||
             (item.notes?.toLowerCase().contains(query) ?? false);
    }).toList();
  }
} 