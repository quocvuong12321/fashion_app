class Payment_Methods {
  String? payment_method_id;
  String? name;
  String? description;

  Payment_Methods({
    required this.payment_method_id,
    required this.name,
    required this.description,
  });

  factory Payment_Methods.fromJson(Map<String, dynamic> json) {
    return Payment_Methods(
      payment_method_id: json['payment_method_id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method_id': payment_method_id,
      'name': name,
      'description': description,
    };
  }
}
