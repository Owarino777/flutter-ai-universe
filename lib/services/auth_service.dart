import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://yodai.wevox.cloud";

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Erreur login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception API login: $e');
      return null;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email.split("@")[0], // simple username
          'password': password,
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
        }),
      );

      print("Register response: ${response.statusCode} - ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Exception API register: $e');
      return false;
    }
  }
}