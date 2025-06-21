import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  String? _userName; 

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName ?? ''; 

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      _isLoggedIn = true;
      await _fetchUserData(); 
      notifyListeners();
    }
    return success;
  }
  
  Future<void> _fetchUserData() async {
    final userData = await _authService.getUserData();
    if (userData != null) {
      _userName = userData['name'];
    }
  }

  Future<void> tryAutoLogin() async {
    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      await _fetchUserData();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _userName = null; 
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    return await _authService.register(name, email, password);
  }
}