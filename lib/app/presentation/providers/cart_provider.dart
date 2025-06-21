import 'package:flutter/material.dart';
import '../../data/models/cart_model.dart';
import '../../data/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  Cart? _cart;
  bool _isLoading = false;
  bool isUserLoggedIn = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;

  double get cartTotal {
    if (_cart == null) {
      return 0.0;
    }

    if (_cart!.items.isEmpty) {
      return 0.0;
    }
    
    double totalCalculado = 0.0;
    for (var item in _cart!.items) {
      totalCalculado += (item.price * item.quantity);
    }

    return totalCalculado;
  }

  get itemCount => null;
  void setIsUserLoggedIn(bool status) {
    isUserLoggedIn = status;
  }

  Future<void> fetchCart() async {
    try {
      if (isUserLoggedIn) {
        _cart = await _cartService.getCart();
      } else {
        _cart = null; 
      }
    } catch (e) {
      print("Falha ao buscar carrinho: $e");
      _cart = null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId) async {
    try {
      _cart = await _cartService.addToCart(productId);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar ao carrinho: $e');
      throw e;
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    _isLoading = true;
    notifyListeners();
    try {
      _cart = await _cartService.updateQuantity(productId, quantity);
    } catch (e) {
      print("Erro ao atualizar quantidade: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int productId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _cart = await _cartService.deleteProduct(productId);
    } catch (e) {
      print("Erro ao deletar produto: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    if (isUserLoggedIn && _cart != null) {
      try {
        await _cartService.clearCart();
        print("Carrinho limpo no servidor com sucesso.");
      } catch (e) {
        print("Não foi possível limpar o carrinho no servidor: $e");
      }
    }
    _cart = null;
    notifyListeners();
  }

  
}