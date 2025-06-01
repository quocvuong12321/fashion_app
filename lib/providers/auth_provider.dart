import 'package:flutter/foundation.dart';

import '../RequestAPI/auth_service.dart';
import '../model/Customer.dart';
 
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Customer? _user;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  Customer? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    print("Login attempt with email: $email and password: $password");
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.login(email, password);

      if (response != null) {
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Login failed. Please check your credentials.";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (!isLoggedIn) {
      _user = null;
    }
    notifyListeners();
  }
  // update user profile
  Future<bool> updateUserProfile(Customer customer) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateUserInfo(customer);
      _user = customer;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  Future<void> updateAvatar(String imagePath) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateAvatar(imagePath);
      _user = _user?.copyWith(image: imagePath);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
