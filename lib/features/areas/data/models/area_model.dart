class Area {
  final int? id;
  final String name;
  final String? photoPath;
  final String areaNumber;
  final DateTime? createdAt;

  Area({
    this.id,
    required this.name,
    this.photoPath,
    required this.areaNumber,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoPath': photoPath,
      'areaNumber': areaNumber,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'],
      name: map['name'],
      photoPath: map['photoPath'],
      areaNumber: map['areaNumber'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Area copyWith({
    int? id,
    String? name,
    String? photoPath,
    String? areaNumber,
    DateTime? createdAt,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      areaNumber: areaNumber ?? this.areaNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
