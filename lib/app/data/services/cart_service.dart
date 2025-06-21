
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cart_model.dart';

class CartService {
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

  Future<Cart> getCart() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/cart/list'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar o carrinho');
    }
  }

  Future<Cart> addToCart(int productId) async {
    final headers = await _getAuthHeaders();
    final body = json.encode({'productId': productId});

    final response = await http.post(
      Uri.parse('$_baseUrl/cart/add'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao adicionar produto ao carrinho');
    }
  }

    Future<Cart> updateQuantity(int productId, int quantity) async {
    final headers = await _getAuthHeaders();
    final body = json.encode({'productId': productId, 'quantity': quantity});

    final response = await http.put(
      Uri.parse('$_baseUrl/cart/update-quantity'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar a quantidade do item');
    }
  }
  
  Future<void> clearCart() async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('$_baseUrl/cart/clear'),
      headers: headers,
    );
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      print('Falha ao limpar carrinho: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao limpar o carrinho no servidor.');
    }
  }

  Future<Cart> deleteProduct(int productId) async {
    final headers = await _getAuthHeaders();
    final body = json.encode({'productId': productId});

    final response = await http.delete(
      Uri.parse('$_baseUrl/cart/delete-product'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao remover o produto do carrinho');
    }
  }
}