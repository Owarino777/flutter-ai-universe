import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = "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";
  final String baseUrl = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> generateResponse(String message, String characterName, String characterDescription) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "https://your-domain.com", // Obligatoire
          "X-Title": "Yod.AI - Aventure",
        },
        body: jsonEncode({
          "model": "mistralai/mistral-7b-instruct", // Modèle gratuit compatible
          "messages": [
            {"role": "system", "content": "Tu es $characterName, $characterDescription. Réponds comme ce personnage."},
            {"role": "user", "content": message},
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"] ?? "Je n'ai pas compris.";
      } else {
        return "Erreur API : ${response.body}";
      }
    } catch (e) {
      return "Erreur de connexion à l'IA : $e";
    }
  }
}
