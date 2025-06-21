import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String _baseUrl = "http://localhost:3001/api/v1/products/find-all"; 

  Future<ApiResponse> fetchProducts({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?page=$page&limit=8'));

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao carregar produtos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}