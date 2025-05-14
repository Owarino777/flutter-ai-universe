import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class MessageService {
  final String baseUrl = "https://yodai.wevox.cloud";

  Future<List<Message>> fetchMessages(String token, int conversationId) async {
    final url = Uri.parse('$baseUrl/conversations/$conversationId/messages');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      print('Erreur chargement messages : ${response.statusCode} - ${response.body}');
      throw Exception('Erreur API : ${response.statusCode}');
    }
  }

  Future<List<Message>> sendMessage(
      String token,
      int conversationId,
      String content,
      ) async {
    final url = Uri.parse('$baseUrl/conversations/$conversationId/messages');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Réponse API : $data'); // Ajouter ce log

      final userMessage = Message.fromJson(data['message']);
      final aiMessage = Message.fromJson(data['answer']);

      return [userMessage, aiMessage];
    } else {
      print('Erreur envoi message : ${response.statusCode} - ${response.body}');
      throw Exception('Erreur API : ${response.statusCode}');
    }
  }
}
