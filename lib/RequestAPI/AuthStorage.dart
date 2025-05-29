import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _usernameKey = 'username';

  static const _nameKey = 'name';
  static const _emailKey = 'email';
  static const _genderKey = 'gender';
  static const _dobKey = 'dob';
  static const _imageKey = 'image';
  static const _phoneKey = 'phone';

  /// Lưu access token và refresh token
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Lấy access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Lấy refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Lưu username
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  /// Lấy username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Lưu thông tin user chi tiết
  static Future<void> saveUserInfo({
    required String name,
    required String email,
    required String gender,
    required String dob,
    String? imageUrl,
    String? phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_genderKey, gender);
    await prefs.setString(_dobKey, dob);
    if (imageUrl != null) await prefs.setString(_imageKey, imageUrl);
    if (phoneNumber != null) await prefs.setString(_phoneKey, phoneNumber);
  }

  /// Lấy thông tin user chi tiết
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey),
      'email': prefs.getString(_emailKey),
      'gender': prefs.getString(_genderKey),
      'dob': prefs.getString(_dobKey),
      'image': prefs.getString(_imageKey),
      'phone': prefs.getString(_phoneKey),
    };
  }

  /// Xoá toàn bộ dữ liệu xác thực và user info
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_genderKey);
    await prefs.remove(_dobKey);
    await prefs.remove(_imageKey);
    await prefs.remove(_phoneKey);
  }
}
