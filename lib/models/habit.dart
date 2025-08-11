class Habit {
  int? id;
  final String name;
  final int categoryId;
  final String categoryName;
  final String colorHex;

  Habit({
    this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.colorHex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'colorHex': colorHex,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      colorHex: map['colorHex'],
    );
  }

  String toJson() {
    return '{"id":$id,"name":"$name","categoryId":$categoryId,"categoryName":"$categoryName","colorHex":"$colorHex"}';
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit.fromMap(json);
  }
}
