// lib/providers/universe_provider.dart
import 'package:flutter/material.dart';
import '../models/universe.dart';
import '../models/character.dart';
import '../services/universe_service.dart';

class UniverseProvider extends ChangeNotifier {
  final UniverseService _universeService = UniverseService();
  List<Universe> _universes = [];

  List<Universe> get universes => _universes;

  Future<List<Universe>> loadUniverses(String token) async {
    _universes = await _universeService.fetchUniverses(token);
    notifyListeners();
    return _universes;
  }

  Future<Universe?> createUniverse(String token, String name, {String? description}) async {
    final newUniverse = await _universeService.createUniverse(token, name);
    if (newUniverse != null) {
      _universes.add(newUniverse);
      notifyListeners();
    }
    return newUniverse;
  }

  Future<List<Character>> loadCharactersForUniverse(String token, Universe universe) async {
    final characters = await _universeService.fetchCharactersOfUniverse(token, universe.id);
    final index = _universes.indexWhere((u) => u.id == universe.id);
    if (index != -1) {
      _universes[index] = Universe(
        id: universe.id,
        name: universe.name,
        description: universe.description,
        image: universe.image,
        creatorId: universe.creatorId,
        createdAt: universe.createdAt,
        updatedAt: universe.updatedAt,
        characters: characters,
      );
      notifyListeners();
    }
    return characters;
  }

  void addCharacterToUniverse(Universe universe, Character character) {
    final index = _universes.indexWhere((u) => u.name == universe.name);
    if (index != -1) {
      _universes[index].characters.add(character);
      notifyListeners();
    }
  }
}
