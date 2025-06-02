import 'dart:convert';
import 'package:fashionshop_app/services/fire-base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import 'package:fashionshop_app/RequestAPI/Token.dart';

class RequestSignIn {
  String username = '';
  String password = '';
  String? accessToken;
  String? refreshToken;
  bool isLoading = false;
  String errorMessage = '';

  void setUsername(String value) {
    username = value;
  }

  void setPassword(String value) {
    password = value;
  }

  String _getBaseUrl() {
    if (ApiService.UrlHien.endsWith('/')) {
      return ApiService.UrlHien;
    } else {
      return ApiService.UrlHien + '/';
    }
  }

  Future<bool> signIn() async {
    isLoading = true;
    errorMessage = '';
    try {
      final baseUrl = _getBaseUrl();
      final token_mobile = await NotificationService.getToken();
      final response = await ApiService.post('user/login', {
        'username': username.trim(),
        'password': password.trim(),
        'token_mobile': token_mobile ?? '',
      }, baseUrl: baseUrl);

      final data = jsonDecode(response.body);

      accessToken = data['result']['access_token'] as String;
      refreshToken = data['result']['refresh_token'] as String;
      final user = data['result']['user'];

      // Lưu token
      await AuthStorage.saveTokens(
        accessToken: accessToken!,
        refreshToken: refreshToken!,
      );
      await AuthStorage.saveUsername(username);

      if (user != null) {
        // Lấy ảnh đại
        String? imageUrl;
        if (user['image'] != null &&
            user['image']['valid'] == true &&
            (user['image']['data'] != null &&
                user['image']['data'].toString().isNotEmpty)) {
          imageUrl = user['image']['data'];
        }

        // Lấy số điện thoại
        String? phoneNumber;
        if (user['addrs'] != null &&
            user['addrs'] is List &&
            (user['addrs'] as List).isNotEmpty) {
          phoneNumber = user['addrs'][0]['phone_number'];
        }

        await AuthStorage.saveUserInfo(
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          gender: user['gender'] ?? '',
          dob: user['dob'] ?? '',
          imageUrl: imageUrl,
          phoneNumber: phoneNumber,
        );
      }

      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = 'Đăng nhập thất bại: $e';
      isLoading = false;
      return false;
    }
  }

  Future<bool> logout() async {
    isLoading = true;
    try {
      final refresh = await AuthStorage.getRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        errorMessage = 'Refresh token không tồn tại hoặc rỗng';
        isLoading = false;
        return false;
      }

      final baseUrl = _getBaseUrl();

      // Gửi logout
      await ApiService.post('user/logout', {
        'refresh_token': refresh,
      }, baseUrl: baseUrl);

      await AuthStorage.clearAuthData();

      accessToken = null;
      refreshToken = null;
      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = 'Đăng xuất thất bại: $e';
      isLoading = false;
      return false;
    }
  }

  Future<String?> refreshAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refresh = prefs.getString('refresh_token');
      if (refresh == null) return null;

      final baseUrl = _getBaseUrl();

      final response = await ApiService.post('auth/refresh', {
        'refreshToken': refresh,
      }, baseUrl: baseUrl);

      final data = jsonDecode(response.body);
      final newAccess = data['result']['accessToken'] as String;

      accessToken = newAccess;
      await prefs.setString('access_token', newAccess);

      return newAccess;
    } catch (e) {
      errorMessage = 'Lỗi refresh token: $e';
      return null;
    }
  }
}
