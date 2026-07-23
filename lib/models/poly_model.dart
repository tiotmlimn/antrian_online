class PolyModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;

  PolyModel({
    required this.id,
    required this.name,
    this.description = '',
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'isActive': isActive,
  };

  factory PolyModel.fromMap(Map<String, dynamic> map) => PolyModel(
    id: map['id'],
    name: map['name'],
    description: map['description'] ?? '',
    isActive: map['isActive'] ?? true,
  );
}
