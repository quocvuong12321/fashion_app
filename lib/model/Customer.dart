class Customer {
  String customerId= "";
  String name="";
  String email="";
  String image="";
  DateTime dob= DateTime.now();
  String gender= "";
  String accountId="";
  DateTime createDate = DateTime.now() ;
  DateTime updateDate = DateTime.now() ;

  Customer({
    required this.customerId,
    required this.name,
    required this.email,
    required this.image,
    required this.dob,
    required this.gender,
    required this.accountId,
    required this.createDate,
    required this.updateDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      accountId: json['account_id'],
      createDate: DateTime.parse(json['create_date']),
      updateDate: DateTime.parse(json['update_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'email': email,
      'image': image,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'account_id': accountId,
      'create_date': createDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
    };
  }
  Customer copyWith({
    String? customerId,
    String? name,
    String? email,
    String? image,
    DateTime? dob,
    String? gender,
    String? accountId,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      accountId: accountId ?? this.accountId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}
