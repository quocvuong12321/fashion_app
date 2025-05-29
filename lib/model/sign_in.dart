
// models/user_model.dart

class UserModel {
  final String name;
  final String email;
  final String gender;
  final String dob;
  final String? imageUrl;
  final List<AddressModel> addresses;

  UserModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.dob,
    required this.imageUrl,
    required this.addresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      imageUrl: json['image']?['valid'] == true ? json['image']['data'] : null,
      addresses: (json['addrs'] as List<dynamic>)
          .map((addr) => AddressModel.fromJson(addr))
          .toList(),
    );
  }

  String get phoneNumber => addresses.isNotEmpty ? addresses[0].phoneNumber : '';
}
// models/address_model.dart

class AddressModel {
  final String id;
  final String customerId;
  final String address;
  final String phoneNumber;

  AddressModel({
    required this.id,
    required this.customerId,
    required this.address,
    required this.phoneNumber,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id_address'] ?? '',
      customerId: json['customer_id'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}



