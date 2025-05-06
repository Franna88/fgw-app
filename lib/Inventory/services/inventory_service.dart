import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';

import '../models/inventory_item.dart';

class InventoryService {
  static const String _storageKey = 'inventory_items';
  static const Uuid _uuid = Uuid();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get current user ID
  String? get _currentUserId => FirebaseService.currentUser?.uid;

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

  String _getFirestoreCollection(String category) {
    // Convert category to snake_case for Firestore collection names
    switch (category) {
      case 'Crops':
        return 'inventory_crops';
      case 'Livestock':
        return 'inventory_livestock';
      case 'Pest Control':
        return 'inventory_pest_control';
      case 'Tools/Equipment':
        return 'inventory_tools_equipment';
      case 'Soil':
        return 'inventory_soil';
      case 'Seeds':
        return 'inventory_seeds';
      case 'Animal Feed':
        return 'inventory_animal_feed';
      default:
        return 'inventory_items';
    }
  }

  // Get user-specific Firestore reference
  CollectionReference _getUserCollection(String collectionName) {
    if (_currentUserId == null) {
      throw Exception('User not logged in');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserId)
        .collection(collectionName);
  }

  // Get items by category
  Future<List<InventoryItem>> getItemsByCategory(String category) async {
    // All categories now use Firestore
    try {
      if (_currentUserId == null) {
        debugPrint('User not logged in, returning empty inventory');
        return [];
      }

      final collectionName = _getFirestoreCollection(category);
      final querySnapshot = await _getUserCollection(collectionName)
          .orderBy('dateAdded', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return InventoryItem(
          id: doc.id,
          name: data['name'] ?? '',
          category: data['category'] ?? category,
          imageUrl: data['imageUrl'] ?? '',
          quantity: data['quantity'] ?? 0,
          unit: data['unit'] ?? 'kg',
          dateAdded:
              (data['dateAdded'] as Timestamp?)?.toDate() ?? DateTime.now(),
          lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
          unitCost: (data['unitCost'] as num?)?.toDouble(),
          notes: data['notes'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading $category from Firestore: $e');
      return [];
    }
  }

  // Add a new item
  Future<InventoryItem> addItem({
    required String name,
    required String category,
    required String imageUrl,
    required int quantity,
    required String unit,
    double? unitCost,
    String? notes,
  }) async {
    // All categories now use Firestore
    try {
      if (_currentUserId == null) {
        throw Exception('User not logged in');
      }

      final collectionName = _getFirestoreCollection(category);
      final docRef = await _getUserCollection(collectionName).add({
        'name': name,
        'category': category,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'unit': unit,
        'unitCost': unitCost,
        'notes': notes,
        'dateAdded': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
        'userId':
            _currentUserId, // Store user ID in the document for additional security
      });

      return InventoryItem(
        id: docRef.id,
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
    } catch (e) {
      debugPrint('Error adding $category to Firestore: $e');
      // Return a dummy item on error
      return InventoryItem(
        id: '',
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
    }
  }

  // Update item quantity in Firestore
  Future<InventoryItem?> updateItemQuantity(
      String itemId, int newQuantity) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not logged in');
      }

      // Find the item in any of the collections
      for (var category in [
        'Crops',
        'Livestock',
        'Pest Control',
        'Tools/Equipment',
        'Soil',
        'Seeds',
        'Animal Feed'
      ]) {
        final collectionName = _getFirestoreCollection(category);
        final docRef = _getUserCollection(collectionName).doc(itemId);
        final doc = await docRef.get();

        if (doc.exists) {
          await docRef.update({
            'quantity': newQuantity,
            'lastUpdated': FieldValue.serverTimestamp(),
          });

          final data = doc.data() as Map<String, dynamic>;
          return InventoryItem(
            id: doc.id,
            name: data['name'] ?? '',
            category: data['category'] ?? category,
            imageUrl: data['imageUrl'] ?? '',
            quantity: newQuantity,
            unit: data['unit'] ?? 'kg',
            dateAdded:
                (data['dateAdded'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lastUpdated: DateTime.now(),
            unitCost: (data['unitCost'] as num?)?.toDouble(),
            notes: data['notes'],
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      return null;
    }
  }

  // Delete an item
  Future<bool> deleteItem(String itemId) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not logged in');
      }

      // Try to find and delete the item in any of the collections
      for (var category in [
        'Crops',
        'Livestock',
        'Pest Control',
        'Tools/Equipment',
        'Soil',
        'Seeds',
        'Animal Feed'
      ]) {
        final collectionName = _getFirestoreCollection(category);
        final docRef = _getUserCollection(collectionName).doc(itemId);
        final doc = await docRef.get();

        if (doc.exists) {
          await docRef.delete();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting item: $e');
      return false;
    }
  }

  // Get inventory categories
  Future<List<String>> getCategories() async {
    return [
      'Crops',
      'Livestock',
      'Pest Control',
      'Tools/Equipment',
      'Soil',
      'Seeds',
      'Animal Feed'
    ];
  }

  // Search inventory items
  Future<List<InventoryItem>> searchItems(String query) async {
    query = query.toLowerCase();
    List<InventoryItem> allItems = [];

    try {
      if (_currentUserId == null) {
        debugPrint('User not logged in, returning empty search results');
        return [];
      }

      // Search through all categories
      for (var category in await getCategories()) {
        final collectionName = _getFirestoreCollection(category);
        final querySnapshot = await _getUserCollection(collectionName).get();

        final items = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return InventoryItem(
            id: doc.id,
            name: data['name'] ?? '',
            category: data['category'] ?? category,
            imageUrl: data['imageUrl'] ?? '',
            quantity: data['quantity'] ?? 0,
            unit: data['unit'] ?? 'kg',
            dateAdded:
                (data['dateAdded'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
            unitCost: (data['unitCost'] as num?)?.toDouble(),
            notes: data['notes'],
          );
        }).where((item) {
          return item.name.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query) ||
              (item.notes?.toLowerCase().contains(query) ?? false);
        });

        allItems.addAll(items);
      }
      return allItems;
    } catch (e) {
      debugPrint('Error searching items: $e');
      return [];
    }
  }
}
