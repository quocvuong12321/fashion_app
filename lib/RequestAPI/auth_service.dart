import 'dart:convert';

import 'package:fashionshop_app/RequestAPI/AuthStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestAPI/api_Services.dart';
import '../model/Customer.dart';

class AuthResponse {
  final Customer user;
  final String token;

  AuthResponse({required this.user, required this.token});
}

class AuthService {
  Future<AuthResponse?> login(String email, String password) async {
    try {
      final response = await ApiService.post('/user/account/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final user = Customer.fromJson(jsonResponse['result']['customer']);
        final token = jsonResponse['result']['token'];

        // Save token and user info in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access token', token);
        await prefs.setString('user_id', user.customerId);
        await prefs.setString(
          'user_data',
          jsonEncode(jsonResponse['result']['customer']),
        );

        return AuthResponse(user: user, token: token);
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_id');
      await prefs.remove('user_data');

      // Optional: Call logout API
      final token = prefs.getString('token');
      if (token != null) {
        await ApiService.post('/user/account/logout', {}, token: token);
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  Future<void> updateUserInfo(Customer user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = await AuthStorage.getRefreshToken();
      print("token = $accessToken");
      final response = await ApiService.patch('user/info/update_customer', {
        'name': user.name,
        'dob': user.dob.toIso8601String(),
        'email': user.email,
        'gender': user.gender,
      }, token: accessToken);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body)['result'];
        await prefs.setString('user_data', jsonEncode(userData));
      } else {
        throw Exception('Failed to update user info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user info: $e');
      throw e;
    }
  }

  Future<void> updateAvatar(String imagePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = await AuthStorage.getRefreshToken().toString();
      final userId = prefs.getString('user_id') ?? '';

      final response = await ApiService.patch(
        'user/info/update_avatar_customer',
        {'customer_id': userId, 'image_path': imagePath},
        token: token,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update avatar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating avatar: $e');
      throw e;
    }
  }
}
