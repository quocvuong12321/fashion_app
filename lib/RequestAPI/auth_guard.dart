import 'dart:convert';
import 'package:fashionshop_app/view/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'Token.dart';
import 'api_Services.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({Key? key, required this.child}) : super(key: key);

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) {
      _goToSignIn();
      return;
    }

    // Kiểm tra accessToken còn hạn không (ví dụ: decode JWT, hoặc gọi API test)
    bool isValid = await _isTokenValid(accessToken);
    if (isValid) {
      setState(() => _checking = false);
      return;
    }

    // Nếu hết hạn, thử refresh token
    String? refreshToken = await AuthStorage.getRefreshToken();
    if (refreshToken != null) {
      bool refreshed = await _refreshToken(refreshToken);
      if (refreshed) {
        setState(() => _checking = false);
        return;
      }
    }

    // Nếu không refresh được, chuyển về đăng nhập
    _goToSignIn();
  }

  Future<bool> _isTokenValid(String token) async {
    // Tuỳ backend, có thể decode JWT hoặc gọi API test
    // Ví dụ: gọi API /me hoặc /profile, nếu 401 thì token hết hạn
    try {
      final res = await ApiService.get('dalogin/ghi', token: token);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final res = await ApiService.post('user/new_access_token', {
        'refresh_token': refreshToken,
      });
      if (res.statusCode == 200) {
        final data = res.body;
        final json = jsonDecode(data);
        final result = json['result'];
        if (result != null && result['access_token'] != null) {
          await AuthStorage.saveTokens(
            accessToken: result['access_token'],
            refreshToken:
                refreshToken, // refresh token cũ hoặc lấy mới nếu backend trả về
          );
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  void _goToSignIn() {
    // context.go("")

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
