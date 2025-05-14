import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  int? _userId;

  String? get token => _token;

  int? get userId => _userId;

  Future<bool> login(String email, String password) async {
    final token = await _authService.login(email, password);
    if (token != null) {
      _token = token;
      final payload = _decodeToken(token);
      _userId = payload["id"];
      notifyListeners();
      return true;
    }
    return false;
  }

  Map<String, dynamic> _decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> decoded = jsonDecode(payload);

    // Vérifie si le champ 'data' existe et est bien un Map
    if (decoded.containsKey('data') && decoded['data'] is Map<String, dynamic>) {
      return decoded['data'];
    }

    // Si 'data' n'est pas un map, on retourne tout le payload décodé
    return decoded;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    return await _authService.register(
      email: email,
      password: password,
      firstname: firstname,
      lastname: lastname,
    );
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}