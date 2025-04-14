import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;

  String? get token => _token;

  get userId => null;

  Future<bool> login(String email, String password) async {
    final token = await _authService.login(email, password);
    if (token != null) {
      _token = token;
      notifyListeners();
      return true;
    }
    return false;
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
