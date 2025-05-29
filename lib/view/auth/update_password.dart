import 'package:flutter/material.dart';
import 'package:fashionshop_app/RequestAPI/request_sign_up.dart';
class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  // Biến dùng để ẩn/hiện mật khẩu
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _isLoading = false;

  // Khởi tạo đối tượng gọi API đổi mật khẩu
  final requestSignUp = RequestSignUp();
  final Color primaryColor = Color.fromARGB(255, 2, 150, 102);

  // Giải phóng controller khi widget bị hủy
  @override
  void dispose() {
    usernameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  // Hàm thực hiện cập nhật mật khẩu
  Future<void> updatePassword() async {
    setState(() => _isLoading = true); 
    // Gọi API để cập nhật mật khẩu
    final success = await requestSignUp.updatePassword(
      username: usernameController.text,
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    );
    setState(() => _isLoading = false); 
    if (!mounted) return;
    // Hiển thị thông báo kết quả
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Cập nhật mật khẩu thành công!' : 'Cập nhật mật khẩu thất bại.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
    if (success) Navigator.pop(context);
  }

  // Hàm tạo InputDecoration cho các ô nhập mật khẩu
  InputDecoration _buildInputDecoration(String label, bool obscure, VoidCallback toggleVisibility) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
      filled: true,
      fillColor: primaryColor.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: primaryColor,
          size: 24,
        ),
        onPressed: toggleVisibility, 
      ),
    );
  }

  // Hàm tạo InputDecoration cho ô nhập username
  InputDecoration _buildUsernameDecoration() {
    return InputDecoration(
      labelText: 'Username',
      prefixIcon: Icon(Icons.person_outline, color: primaryColor),
      filled: true,
      fillColor: primaryColor.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, size: 26, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) 
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: _buildUsernameDecoration(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: oldPasswordController,
                      obscureText: _obscureOldPassword,
                      decoration: _buildInputDecoration('Mật khẩu cũ', _obscureOldPassword, () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword; 
                        });
                      }),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: _buildInputDecoration('Mật khẩu mới', _obscureNewPassword, () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword; 
                        });
                      }),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: updatePassword, // Gọi hàm cập nhật mật khẩu
                        icon: const Icon(Icons.update, size: 20, color: Colors.white),
                        label: const Text(
                          'Lưu',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: primaryColor.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
