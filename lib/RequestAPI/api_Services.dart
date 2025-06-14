import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Token.dart';

class ApiService {
  static const String UrlHien = 'https://c82a-118-70-226-27.ngrok-free.app/v1/';
  static const String UrlVuong =
      'https://0e2b-2405-4802-9398-6100-34d1-412a-fdb9-6303.ngrok-free.app/';
  static Future<String?> token = AuthStorage.getRefreshToken();

  static Map<String, String> createHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(
    String endpoint, {
    String baseUrl =
        UrlHien, //mặc định là url của HIển. Nếu đưa nào gọi API của t thì truyền gán lại base URL
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: createHeaders(token: token),
    );
    _handleErrors(response);
    print(token);
    return response;
  }

  /// POST
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String baseUrl = UrlHien,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: createHeaders(token: token),
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  /// PUT
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    String baseUrl = UrlHien,
    String? token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: createHeaders(token: token),
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  // PATCH

  static Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body, {
    String baseUrl = UrlHien,
    String? token,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: createHeaders(token: token),
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  /// DELETE
  static Future<http.Response> delete(
    String endpoint, {
    String baseUrl = UrlHien,
    String? token,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: createHeaders(token: token),
    );
    _handleErrors(response);
    return response;
  }

  // Optional: Error handler
  static void _handleErrors(http.Response response) {
    if (response.statusCode >= 500) {
      throw Exception(
        'HTTP Error: ${response.statusCode}\nBody: ${response.body}',
      );
    }
  }
}
