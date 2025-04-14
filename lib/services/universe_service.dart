// lib/services/universe_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
