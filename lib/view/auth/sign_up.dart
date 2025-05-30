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
                SizedBox(height: 13),
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTextFormField(_emailController, 'Email'),
                Text(
                  'Date of Birth',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _dobController.text = _displayDateFormat.format(
                        pickedDate,
                      );
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: 'Ngày sinh',
                        hintText: 'YYYY-MM-DD',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn ngày sinh';
                        }
                        try {
                          _displayDateFormat.parseStrict(value);
                        } catch (_) {
                          return 'Sai định dạng ngày (YYYY-MM-DD)';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 13),
                Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildGenderDropdown(),
                SizedBox(height: 13),
                SizedBox(height: 13),

                SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () async {
                                if (!_formKey.currentState!.validate()) return;

                                requestSignUp.setUsername(
                                  _usernameController.text,
                                );
                                requestSignUp.setPassword(
                                  _passwordController.text,
                                );
                                requestSignUp.setName(_nameController.text);

                                try {
                                  DateTime parsed = _displayDateFormat.parse(
                                    _dobController.text,
                                  );
                                  requestSignUp.setDob(
                                    _apiDateFormat.format(parsed),
                                  );
                                } catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ngày sinh không hợp lệ.'),
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
                                      success
                                          ? 'Đăng ký thành công!'
                                          : errorMessage,
                                    ),
                                    backgroundColor:
                                        success ? Colors.green : Colors.red,
                                  ),
                                );

                                if (success) {
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/signin',
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child:
                          isLoading
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
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscureText : obscureText,
      readOnly: controller == _dobController,
      decoration: InputDecoration(
        hintText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon:
            controller == _dobController
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
        if (value == null || value.isEmpty) return 'Please enter $labelText';
        if (dateValidation) {
          try {
            _displayDateFormat.parseStrict(value);
          } catch (_) {
            return 'Invalid date format (YYYY-MM-DD)';
          }
        }
        return null;
      },
      onTap:
          controller == _dobController
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
      items:
          ['Nam', 'Nữ']
              .map(
                (gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)),
              )
              .toList(),
      onChanged: (value) => setState(() => _gender = value),
      validator: (value) => value == null ? 'Please select gender' : null,
    );
  }

  Widget _buildSocialLoginButtons(
    String text,
    String assetPath,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(assetPath, height: 24, width: 24),
              ),
              SizedBox(width: 80),
              Text(text, style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
