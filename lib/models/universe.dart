import 'character.dart';

class Universe {
  final String name;
  final String description;
  final String imageUrl;
  final List<Character> characters;

  Universe({
    required this.name,
    required this.description,
    required this.imageUrl,
    List<Character>? characters,
  }) : characters = characters ?? [];

  void addCharacter(Character character) {
    characters.add(character);
  }
}
