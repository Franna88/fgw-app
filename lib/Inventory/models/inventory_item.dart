class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  int quantity;
  String unit;
  final DateTime dateAdded;
  DateTime? lastUpdated;
  double? unitCost;
  String? notes;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
    required this.dateAdded,
    this.lastUpdated,
    this.unitCost,
    this.notes,
  });

  // Create a deep copy of the item
  InventoryItem copy() {
    return InventoryItem(
      id: id,
      name: name,
      category: category,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      dateAdded: dateAdded,
      lastUpdated: lastUpdated,
      unitCost: unitCost,
      notes: notes,
    );
  }

  // Update quantity and last updated timestamp
  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
    lastUpdated = DateTime.now();
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'unit': unit,
      'dateAdded': dateAdded.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'unitCost': unitCost,
      'notes': notes,
    };
  }

  // Create from Map for retrieval
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
      unit: map['unit'],
      dateAdded: DateTime.parse(map['dateAdded']),
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated']) 
          : null,
      unitCost: map['unitCost'],
      notes: map['notes'],
    );
  }
} 