class Discount {
  String discountId;
  String discountCode;
  double discountValue;
  DateTime startDate;
  DateTime endDate;
  double minOrderValue;
  int amount;
  DateTime createDate;
  DateTime updateDate;

  Discount({
    required this.discountId,
    required this.discountCode,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.minOrderValue,
    required this.amount,
    required this.createDate,
    required this.updateDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'discount_id': discountId,
      'discount_code': discountCode,
      'discount_value': discountValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'min_order_value': minOrderValue,
      'amount': amount,
      'create_date': createDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
    };
  }
}
