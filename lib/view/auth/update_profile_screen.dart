import 'package:flutter/material.dart';
import 'package:fashionshop_app/RequestAPI/Token.dart';
import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import 'dart:convert';

import '../../RequestAPI/AuthStorage.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name, email, gender, dob;
  String? imageUrl, phoneNumber; // thêm 2 biến này
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final userInfo = await AuthStorage.getUserInfo();
    setState(() {
      name = userInfo['name'];
      email = userInfo['email'];
      gender = userInfo['gender'];
      dob = userInfo['dob'];
      imageUrl = userInfo['image'];      // load ảnh
      phoneNumber = userInfo['phone'];   // load số điện thoại
    });
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    final baseUrl = ApiService.UrlHien;

    try {
      final response = await ApiService.put(
        'user/update-profile',
        {
          'name': name,
          'email': email,
          'gender': gender,
          'dob': dob,
          'image': imageUrl,      // gửi ảnh lên server
          'phone': phoneNumber,   // gửi số điện thoại lên server
        },
        baseUrl: baseUrl,
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await AuthStorage.saveUserInfo(
          name: name ?? '',
          email: email ?? '',
          gender: gender ?? '',
          dob: dob ?? '',
          imageUrl: imageUrl,
          phoneNumber: phoneNumber,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật thành công")),
        );
        Navigator.pop(context);
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal.shade700),
      filled: true,
      fillColor: Colors.teal.shade50,
      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cập nhật thông tin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: buildInputDecoration('Tên', Icons.badge),
                      onSaved: (value) => name = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Không để trống' : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: email,
                      decoration:
                          buildInputDecoration('Email', Icons.email_outlined),
                      onSaved: (value) => email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Không để trống';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: gender,
                      decoration: buildInputDecoration('Giới tính', Icons.wc),
                      onSaved: (value) => gender = value,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: dob,
                      decoration:
                          buildInputDecoration('Ngày sinh (yyyy-MM-dd)', Icons.cake_outlined),
                      onSaved: (value) => dob = value,
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: phoneNumber,
                      decoration: buildInputDecoration('Số điện thoại', Icons.phone),
                      onSaved: (value) => phoneNumber = value,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: imageUrl,
                      decoration: buildInputDecoration('Ảnh (URL)', Icons.image),
                      onSaved: (value) => imageUrl = value,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton.icon(
                          onPressed: updateProfile,
                          icon: const Icon(Icons.update, size: 18),
                          label: const Text(
                            'Lưu',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 3,
                            minimumSize: Size(0, 36),
                          ),
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
