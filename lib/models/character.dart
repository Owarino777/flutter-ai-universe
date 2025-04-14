// character.dart
class Character {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    imageUrl: json["image"],
  );
}
