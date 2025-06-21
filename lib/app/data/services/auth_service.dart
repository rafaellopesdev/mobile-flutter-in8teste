import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _baseUrl = "http://localhost:3001/api/v1";
  final _storage = const FlutterSecureStorage();

  Map<String, dynamic>? _decodeToken(String token) {
    try {
      final String normalizedToken = base64.normalize(token);
      final payload = utf8.decode(base64.decode(normalizedToken));
      final decodedJson = json.decode(payload);

      final int now = DateTime.now().millisecondsSinceEpoch;
      if (decodedJson['exp'] != null && now > decodedJson['exp']) {
        print("Token expirado.");
        return null;
      }

      return decodedJson;
    } catch (e) {
      print("Erro ao decodificar token: $e");
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['token'] != null) {
        final token = data['token'];
        await _storage.write(key: 'authToken', value: token);
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/accounts/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final token = await _storage.read(key: 'authToken');
    if (token == null) {
      return null;
    }
    return _decodeToken(token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'authToken');
    if (token == null) {
      return false;
    }
    // Verifica se o token decodificado é válido e não expirou
    return _decodeToken(token) != null;
  }
}