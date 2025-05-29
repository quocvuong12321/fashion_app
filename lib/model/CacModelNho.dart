class Payment {
  String? description;
  String name;
  String paymentMethodId;

  Payment({
    required this.name,
    required this.description,
    required this.paymentMethodId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      description: json['description']["data"],
      name: json['name'],
      paymentMethodId: json['payment_method_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'payment_method_id': paymentMethodId,
    };
  }
}

class CustomerAddress {
  String address;
  String customerId;
  String idAddress;
  String phoneNumber;

  CustomerAddress({
    required this.address,
    required this.customerId,
    required this.idAddress,
    required this.phoneNumber,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      address: json['address'],
      customerId: json['customer_id'],
      idAddress: json['id_address'],
      phoneNumber: json['phone_number'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'customer_id': customerId,
      'id_address': idAddress,
      'phone_number': phoneNumber,
    };
  }
}

class Discount {
  int amount;
  String discountCode;
  String discountId;
  double discountValue;
  DateTime endDate;
  DateTime startDate;
  double minOrderValue;
  String statusDisCount;

  Discount({
    required this.discountId,
    required this.startDate,
    required this.endDate,
    required this.discountCode,
    required this.discountValue,
    required this.amount,
    required this.minOrderValue,
    required this.statusDisCount,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      discountId: json['discount_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      discountCode: json['discount_code'],
      discountValue: double.parse(json['discount_value'].toString()),
      amount: int.parse(json['amount'].toString()),
      minOrderValue: double.parse(json['min_order_value'].toString()),
      statusDisCount: json['status_discount'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'discount_id': discountId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'discount_code': discountCode,
      'discount_value': discountValue,
      'amount': amount,
      'min_order_value': minOrderValue,
      'status_discount': statusDisCount,
    };
  }
}
