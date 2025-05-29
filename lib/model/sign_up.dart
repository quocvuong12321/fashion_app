class SignUpModel {
  final bool isLoading;
  final String username;
  final String password;
  final String name;
  final String dob;
  final String gender;
  final String email;
  final String? errorMessage;

  SignUpModel({
    required this.isLoading,
    required this.username,
    required this.password,
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    this.errorMessage,
  });

  // Hàm khởi tạo mặc định
  factory SignUpModel.initial() {
    return SignUpModel(
      isLoading: false,
      username: '',
      password: '',
      name: '',
      dob: '',
      gender: '',
      email: '',
      errorMessage: null,
    );
  }

  // Hàm sao chép và thay đổi các thuộc tính
  SignUpModel copyWith({
    bool? isLoading,
    String? username,
    String? password,
    String? name,
    String? dob,
    String? gender,
    String? email,
    String? errorMessage,
  }) {
    return SignUpModel(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Hàm chuyển đổi từ JSON sang SignUpModel
  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      isLoading: json['is_loading'] ?? false,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      errorMessage: json['error_message'],
    );
  }

  // Hàm chuyển đổi từ SignUpModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'is_loading': isLoading,
      'username': username,
      'password': password,
      'name': name,
      'dob': dob,
      'gender': gender,
      'email': email,
      'error_message': errorMessage,
    };
  }
}
