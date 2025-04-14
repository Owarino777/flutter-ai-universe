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

  void addUniverse(Universe universe) {
    _universes.add(universe);
    notifyListeners();
  }

  void addCharacterToUniverse(Universe universe, Character character) {
    final index = _universes.indexWhere((u) => u.name == universe.name);
    if (index != -1) {
      _universes[index].characters.add(character);
      notifyListeners();
    }
  }
}
