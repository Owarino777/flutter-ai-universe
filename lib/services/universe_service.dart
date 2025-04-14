// lib/services/universe_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/conversation.dart';
import '../models/universe.dart';

class UniverseService {
  final String baseUrl = "https://yodai.wevox.cloud";

  Future<List<Universe>> fetchUniverses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((u) => Universe.fromJson(u)).toList();
    } else {
      print('Erreur API: ${response.statusCode} - ${response.body}');  // 👈 Ajoute ceci
      throw Exception('Erreur API (${response.statusCode}) : ${response.body}');
    }
  }

  Future<Universe?> createUniverse(String token, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return Universe.fromJson(jsonDecode(response.body));
    } else {
      print('Erreur création univers: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<List<Character>> fetchCharactersOfUniverse(String token, int universeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des personnages : ${response.statusCode}");
    }
  }

  Future<Character?> createCharacter(String token, int universeId, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      print('Erreur création personnage: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<List<Conversation>> fetchAllConversations(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Conversation.fromJson(e)).toList();
    } else {
      throw Exception("Erreur récupération conversations : ${response.statusCode}");
    }
  }

  Future<Conversation?> createConversation(String token, int characterId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "character_id": characterId,
        "user_id": userId,
      }),
    );

    if (response.statusCode == 201) {
      return Conversation.fromJson(jsonDecode(response.body));
    } else {
      print("Erreur création conversation : ${response.body}");
      return null;
    }
  }
}
