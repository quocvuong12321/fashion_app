import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'sign_in.dart';
import 'package:fashionshop_app/RequestAPI/request_sign_up.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? _gender;

  final DateFormat _displayDateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestSignUp = Provider.of<RequestSignUp>(context);
    final isLoading = requestSignUp.isLoading;
    final errorMessage = requestSignUp.errorMessage;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Join us and explore the fashion world!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTextFormField(_usernameController, 'Username'),
                SizedBox(height: 13),
                Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTextFormField(
                  _passwordController,
                  'Password',
                  obscureText: true,
                ),
                SizedBox(height: 13),
                Text(
                  'Full Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildTextFormField(_nameController, 'Name'),
                SizedBox(height: 13),
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTextFormField(_emailController, 'Email'),
                SizedBox(height: 13),
                Text(
                  'Date of Birth',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildTextFormField(
                  _dobController,
                  'Date of Birth',
                  dateValidation: true,
                ),
                SizedBox(height: 13),
                Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildGenderDropdown(),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign up',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 13),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignInScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText, {
    bool obscureText = false,
    bool dateValidation = false,
  }) {
    bool isPassword = labelText.toLowerCase().contains('password');
    bool isEmail = labelText.toLowerCase().contains('email');
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscureText : obscureText,
      readOnly: controller == _dobController,
      decoration: InputDecoration(
        hintText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: controller == _dobController
            ? Icon(Icons.calendar_today)
            : isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $labelText';
        }

        // Kiểm tra email
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Email không hợp lệ';
          }
        }

        // Kiểm tra password
        if (isPassword) {
          if (value.length < 6) {
            return 'Mật khẩu phải có ít nhất 6 ký tự';
          }
          if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
            return 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt';
          }
        }

        // Kiểm tra ngày sinh
        if (dateValidation) {
          try {
            final date = _displayDateFormat.parseStrict(value);
            if (date.isAfter(DateTime.now())) {
              return 'Ngày sinh không thể lớn hơn ngày hiện tại';
            }
          } catch (_) {
            return 'Định dạng ngày không hợp lệ (YYYY-MM-DD)';
          }
        }
        return null;
      },
      onTap: controller == _dobController
          ? () async {
              DateTime initialDate = DateTime.now();
              try {
                if (_dobController.text.isNotEmpty) {
                  initialDate = _displayDateFormat.parse(_dobController.text);
                }
              } catch (_) {}
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _dobController.text = _displayDateFormat.format(pickedDate);
              }
            }
          : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: ['Nam', 'Nữ']
          .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
      onChanged: (value) => setState(() => _gender = value),
      validator: (value) => value == null ? 'Please select gender' : null,
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final requestSignUp = Provider.of<RequestSignUp>(context, listen: false);
    requestSignUp.setUsername(_usernameController.text);
    requestSignUp.setPassword(_passwordController.text);
    requestSignUp.setName(_nameController.text);

    try {
      DateTime parsed = _displayDateFormat.parse(_dobController.text);
      requestSignUp.setDob(_apiDateFormat.format(parsed));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ngày sinh không hợp lệ.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    requestSignUp.setGender(_gender ?? '');
    requestSignUp.setEmail(_emailController.text);

    bool success = await requestSignUp.signUp();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Đăng ký thành công!' : requestSignUp.errorMessage,
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: success ? 2 : 4),
      ),
    );

    if (success) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }
}
