import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashionshop_app/RequestAPI/Token.dart';
import '../view/auth/update_password.dart';
import '../view/auth/sign_in.dart';
import '../RequestAPI/request_sign_in.dart';

class Account_Screen extends StatefulWidget {
  const Account_Screen({Key? key}) : super(key: key);
  @override
  State<Account_Screen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<Account_Screen> {
  String? username;
  String? name;
  String? email;
  String? gender;
  String? dob;
  String? imageUrl;
  String? phoneNumber;

  bool isLoggingOut = false;
  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  // Hàm tải thông tin người dùng từ local
  Future<void> loadUserInfo() async {
    final storedUsername = await AuthStorage.getUsername();
    final userInfo = await AuthStorage.getUserInfo();

    // Cập nhật giao diện với thông tin người dùng
    setState(() {
      username = storedUsername;
      name = userInfo['name'];
      email = userInfo['email'];
      gender = userInfo['gender'];
      dob = userInfo['dob'];
      imageUrl = userInfo['image'];
      phoneNumber = userInfo['phone'];
    });
  }

  // Hàm dựng một dòng hiển thị thông tin
  Widget buildInfoTile(
    String title,
    String? value,
    IconData icon,
    Color primaryColor,
  ) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(value ?? '-', style: GoogleFonts.montserrat()),
    );
  }

  // Hàm xác nhận và xử lý đăng xuất
  Future<void> confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc muốn đăng xuất không?'),
            actions: [
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Đăng xuất'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        isLoggingOut = true;
      });
      final requestSignIn = RequestSignIn();
      final success = await requestSignIn.logout(); // Gọi API đăng xuất
      if (success) {
        // Xoá thông tin người dùng trong app
        setState(() {
          isLoggingOut = false;
          username = null;
          name = null;
          email = null;
          gender = null;
          dob = null;
          imageUrl = null;
          phoneNumber = null;
        });
        // Chuyển về màn hình đăng nhập
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } else {
        setState(() {
          isLoggingOut = false;
        });
        // Hiển thị lỗi nếu không đăng xuất thành công
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(requestSignIn.errorMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 2, 150, 102);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Tài khoản',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Đăng xuất',
            onPressed: confirmLogout,
          ),
        ],
      ),

      body:
          isLoggingOut
              ? const Center(child: CircularProgressIndicator())
              : username != null
              ? SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ảnh đại diện
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor.withOpacity(0.2),
                      backgroundImage:
                          (imageUrl != null && imageUrl!.isNotEmpty)
                              ? NetworkImage(imageUrl!)
                              : null,
                      child:
                          (imageUrl == null || imageUrl!.isEmpty)
                              ? Icon(
                                Icons.person,
                                size: 50,
                                color: primaryColor,
                              )
                              : null,
                    ),
                    const SizedBox(height: 20),

                    // Thẻ thông tin
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          buildInfoTile('Tên', name, Icons.badge, primaryColor),
                          buildInfoTile(
                            'Email',
                            email,
                            Icons.email_outlined,
                            primaryColor,
                          ),
                          buildInfoTile(
                            'Giới tính',
                            gender,
                            Icons.wc,
                            primaryColor,
                          ),
                          buildInfoTile(
                            'Ngày sinh',
                            dob,
                            Icons.cake_outlined,
                            primaryColor,
                          ),
                          buildInfoTile(
                            'Số điện thoại',
                            phoneNumber,
                            Icons.phone,
                            primaryColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nút đổi mật khẩu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.lock_outline,
                            size: 22,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Đổi mật khẩu',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: primaryColor.withOpacity(0.5),
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const UpdatePasswordScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.edit,
                            size: 22,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Chỉnh sửa thông tin',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: const Color.fromARGB(255, 2, 150, 102),
                            backgroundColor: const Color.fromARGB(
                              255,
                              2,
                              150,
                              102,
                            ),
                          ),
                          onPressed: () {
                            // chuyển đến UpdateProfileScreen (mở comment để sử dụng)
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                            // );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : Center(
                // Giao diện khi chưa đăng nhập
                child: Text(
                  'Chưa đăng nhập',
                  style: GoogleFonts.montserrat(fontSize: 18),
                ),
              ),
    );
  }
}
