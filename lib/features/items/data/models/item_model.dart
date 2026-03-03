class Item {
  final int? id;
  final String name;
  final String category; // 'Vegetable' or 'Medicine'
  final double price;
  final double mrp;
  final String unit; // 'kg', 'unit', etc.
  final bool isEnabled;
  final DateTime? createdAt;

  Item({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.mrp,
    required this.unit,
    this.isEnabled = true,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'mrp': mrp,
      'unit': unit,
      'isEnabled': isEnabled ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      price: map['price'],
      mrp: map['mrp'],
      unit: map['unit'],
      isEnabled: map['isEnabled'] == 1,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Item copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    double? mrp,
    String? unit,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      unit: unit ?? this.unit,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
