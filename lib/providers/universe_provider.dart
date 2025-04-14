// lib/providers/universe_provider.dart
import 'package:flutter/material.dart';
import '../models/universe.dart';
import '../models/character.dart';

class UniverseProvider extends ChangeNotifier {
  final List<Universe> _universes = [
    Universe(name: "Terres Maudites", description: "Un monde sombre et mystique.", imageUrl: "assets/images/universe1.jpg"),
    Universe(name: "Cité Céleste", description: "Un royaume flottant parmi les nuages.", imageUrl: "assets/images/universe2.jpg"),
    Universe(name: "Forêt des Anciens", description: "Un bois enchanté peuplé d'esprits.", imageUrl: "assets/images/universe3.jpg"),
  ];

  List<Universe> get universes => _universes;

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
