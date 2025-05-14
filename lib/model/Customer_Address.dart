class Customer_Address {
  String idAddress;
  String customerId;
  String address;
  String phoneNumber;
  DateTime createDate;
  DateTime updateDate;

  Customer_Address({
    required this.idAddress,
    required this.customerId,
    required this.address,
    required this.phoneNumber,
    required this.createDate,
    required this.updateDate,
  });

  factory Customer_Address.fromJson(Map<String, dynamic> json) {
    return Customer_Address(
      idAddress: json['id_address'],
      customerId: json['customer_id'],
      address: json['address'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      createDate: DateTime.parse(json['create_date'] ?? '0001-01-01T00:00:00Z'),
      updateDate: DateTime.parse(
        json['update_date']['data'] ?? '0001-01-01T00:00:00Z',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_address': idAddress,
      'customer_id': customerId,
      'address': address,
      'phone_number': phoneNumber,
      'create_date': createDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
    };
  }
}
