class Customer {
  final int? id;
  final String name;
  final String phone;
  final String? address;
  final String? houseNumber;
  final int areaId;
  final String? locationLink;
  final String? photoPath;
  final String? notes;
  final DateTime? createdAt;

  Customer({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.houseNumber,
    required this.areaId,
    this.locationLink,
    this.photoPath,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'houseNumber': houseNumber,
      'areaId': areaId,
      'locationLink': locationLink,
      'photoPath': photoPath,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      houseNumber: map['houseNumber'],
      areaId: map['areaId'],
      locationLink: map['locationLink'],
      photoPath: map['photoPath'],
      notes: map['notes'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? houseNumber,
    int? areaId,
    String? locationLink,
    String? photoPath,
    String? notes,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      houseNumber: houseNumber ?? this.houseNumber,
      areaId: areaId ?? this.areaId,
      locationLink: locationLink ?? this.locationLink,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
