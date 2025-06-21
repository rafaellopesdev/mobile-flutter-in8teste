import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> createOrder(Order order) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _orderService.createOrder(order);
      return success;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}