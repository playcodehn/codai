class Category {
  int? id;
  final String name;
  final String iconPath;
  final String colorHex;
  int habitCount;

  Category({
    this.id,
    required this.name,
    required this.iconPath,
    required this.colorHex,
    this.habitCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'colorHex': colorHex,
      'habitCount': habitCount,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconPath: map['iconPath'],
      colorHex: map['colorHex'],
      habitCount: map['habitCount'] ?? 0,
    );
  }

  String toJson() {
    return '{"id":$id,"name":"$name","iconPath":"$iconPath","colorHex":"$colorHex","habitCount":$habitCount}';
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category.fromMap(json);
  }
}
