import 'dart:convert';
import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import 'dart:io';
import 'dart:async';

class RequestSignUp {
  String username = '';
  String password = '';
  String name = '';
  String dob = '';
  String gender = '';
  String email = '';

  bool isLoading = false;
  String errorMessage = '';

  void setUsername(String value) => username = value.trim();
  void setPassword(String value) => password = value.trim();
  void setName(String value) => name = value.trim();
  void setDob(String value) => dob = value.trim();
  void setGender(String value) => gender = value.trim();
  void setEmail(String value) => email = value.trim();

  String _getBaseUrl() {
    if (ApiService.UrlHien.endsWith('/')) {
      return ApiService.UrlHien;
    } else {
      return ApiService.UrlHien + '/';
    }
  }

  String _formatDob(String dob) {
    if (dob.isEmpty) {
      errorMessage = 'Ngày sinh không được để trống.';
      print(' Lỗi: $errorMessage');
      return '';
    }
    try {
      final parsedDate = DateTime.parse(dob);
      return parsedDate.toUtc().toIso8601String();
    } catch (e) {
      errorMessage = 'Ngày sinh không hợp lệ. Định dạng đúng là yyyy-MM-dd.';
      print(' Lỗi: $errorMessage');
      return '';
    }
  }
  Future<bool> signUp() async {
  isLoading = true;
  errorMessage = '';

  final formattedDob = _formatDob(dob);
  if (formattedDob.isEmpty) {
    isLoading = false;
    return false;
  }

  try {
    final baseUrl = _getBaseUrl();
    final response = await ApiService.post(
      'user/register',
      {
        'username': username,
        'password': password,
        'name': name,
        'email': email,
        'dob': formattedDob,
        'gender': gender,
      },
      baseUrl: baseUrl,
    );

    final data = jsonDecode(response.body);

    print('Phản hồi server: ${response.body}');

    // Kiểm tra theo giá trị thực tế trả về từ server
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data['status'] == 'success' &&
        (data['message']?.toString().toLowerCase().contains('success') ?? false)) {
      print('Đăng ký thành công!');
      isLoading = false;
      return true;
    } else {
      errorMessage = data['message'] ?? 'Đăng ký thất bại.';
      print('Đăng ký thất bại. Mã lỗi: ${response.statusCode}');
      print('Lỗi: $errorMessage');
      isLoading = false;
      return false;
    }
  } on FormatException catch (e) {
    errorMessage = 'Dữ liệu không hợp lệ: ${e.message}';
    print('Lỗi FormatException: $errorMessage');
    isLoading = false;
    return false;
  } on TimeoutException catch (_) {
    errorMessage = 'Lỗi kết nối: Yêu cầu mất quá nhiều thời gian.';
    print('Lỗi TimeoutException: $errorMessage');
    isLoading = false;
    return false;
  } on SocketException catch (_) {
    errorMessage = 'Lỗi kết nối: Không thể kết nối đến máy chủ.';
    print('Lỗi SocketException: $errorMessage');
    isLoading = false;
    return false;
  } catch (e) {
    errorMessage = 'Lỗi không xác định: $e';
    print('Lỗi không xác định: $errorMessage');
    isLoading = false;
    return false;
  }
}

  Future<bool> updatePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading = true;
    errorMessage = '';

    try {
      final baseUrl = _getBaseUrl();
      final response = await ApiService.post(
        'user/updatePassword',
        {
          'username': username.trim(),
          'old_password': oldPassword.trim(),
          'new_password': newPassword.trim(),
        },
        baseUrl: baseUrl,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isLoading = false;
        return true;
      } else {
        errorMessage = data['message'] ?? 'Đổi mật khẩu thất bại.';
        print('Đổi mật khẩu thất bại. Mã lỗi: ${response.statusCode}');
        print('Phản hồi server: ${response.body}');
        print('Lỗi: $errorMessage');
        isLoading = false;
        return false;
      }
    } on FormatException catch (e) {
      errorMessage = 'Dữ liệu không hợp lệ: ${e.message}';
      print('Lỗi FormatException: $errorMessage');
      isLoading = false;
      return false;
    } on TimeoutException catch (_) {
      errorMessage = 'Lỗi kết nối: Yêu cầu mất quá nhiều thời gian.';
      print('Lỗi TimeoutException: $errorMessage');
      isLoading = false;
      return false;
    } on SocketException catch (_) {
      errorMessage = 'Lỗi kết nối: Không thể kết nối đến máy chủ.';
      print('Lỗi SocketException: $errorMessage');
      isLoading = false;
      return false;
    } catch (e) {
      errorMessage = 'Lỗi không xác định: $e';
      print('Lỗi không xác định: $errorMessage');
      isLoading = false;
      return false;
    }
  }
}
