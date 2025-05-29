import 'package:flutter/material.dart';
import 'package:fashionshop_app/RequestAPI/resquest_sign_up.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _isLoading = false;
  final requestSignUp = RequestSignUp();

  @override
  void dispose() {
    usernameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    setState(() => _isLoading = true);

    final success = await requestSignUp.updatePassword(
      username: usernameController.text,
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

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

  InputDecoration _buildInputDecoration(String label, bool obscure, VoidCallback toggleVisibility) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[600],
          size: 24,
        ),
        onPressed: toggleVisibility,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        automaticallyImplyLeading: false, // Ẩn nút back mặc định bên trái
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon khóa + text 'Đổi mật khẩu'
            Row(
              children: const [
                Icon(Icons.lock_outline, size: 26),
                SizedBox(width: 8),
                Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // Nút back với mũi tên quay ra bên phải
            IconButton(
              icon: const Icon(Icons.arrow_forward), // mũi tên quay phải
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
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                        height: 40,
                        child: ElevatedButton(
                          onPressed: updatePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.update, size: 20),
                              SizedBox(width: 8),
                              Text('Lưu'),
                            ],
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
