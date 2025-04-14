import 'character.dart';

class Universe {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final int creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Character> characters; // ← liste manquante rétablie

  Universe({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    List<Character>? characters,
  }) : characters = characters ?? [];

  factory Universe.fromJson(Map<String, dynamic> json) => Universe(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    creatorId: json["creator_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    characters: (json['characters'] as List<dynamic>?)
        ?.map((charJson) => Character.fromJson(charJson))
        .toList() ??
        [],
  );

  void addCharacter(Character character) {
    characters.add(character);
  }
}
