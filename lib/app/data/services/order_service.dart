// lib/app/data/services/order_service.dart

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/order_model.dart';

class OrderService {
  final String _baseUrl = "http://localhost:3001/api/v1";
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'authToken');
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> createOrder(Order order) async {
    final headers = await _getAuthHeaders();
    final body = order.toJson();

    print(body);

    final response = await http.post(
      Uri.parse('$_baseUrl/orders/create'),
      headers: headers,
      body: body,
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print('Falha ao criar pedido: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao criar o pedido.');
    }
  }
}