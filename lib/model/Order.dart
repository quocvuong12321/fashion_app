// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fashionshop_app/model/Customer_Address.dart';
import 'package:fashionshop_app/model/Order_Detail.dart';

class Order {
  final String? order_id;
  final double? total_amount;
  final String? customer_address_id;
  final String? discount_id;
  final String? payment_method_name;
  final String payment_status;
  final String? order_status;
  final DateTime create_date;
  final DateTime update_date;
  final String? customer_id;
  final Customer_Address customer_address;
  final List<Order_Detail> order_detail;

  Order({
    required this.order_id,
    required this.total_amount,
    required this.customer_address_id,
    required this.discount_id,
    required this.payment_status,
    required this.order_status,
    required this.create_date,
    required this.update_date,
    required this.customer_id,
    required this.customer_address,
    required this.payment_method_name,
    required this.order_detail,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      order_id: json['order_id'] ?? "",
      total_amount: (json['total_amount'] ?? 0 as num).toDouble(),
      customer_address_id: json['customer_address_id'] ?? "",
      discount_id:
          json['discount_code'] != null && json['discount_code'] is Map
              ? json['discount_code']['data'] ?? ""
              : "",
      payment_status: json['payment_status'] ?? "",
      order_status: json['order_status'] ?? "",
      payment_method_name: json['payment_method']['data']['name'] ?? "",
      create_date: DateTime.parse(
        json['create_date'] ?? '0001-01-01T00:00:00Z',
      ),
      update_date: DateTime.parse(
        json['update_date']['data'] ?? '0001-01-01T00:00:00Z',
      ),
      customer_id: json['customer_id'] ?? "",
      customer_address: Customer_Address.fromJson(
        json['customer_address']['data'] ?? Null,
      ),
      order_detail: Order_Detail.fromjsonList(json['order_detail']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'total_amount': total_amount,
      'customer_address_id': customer_address_id,
      'discount_id': discount_id,
      'payment_status': payment_status,
      'order_status': order_status,
      'create_date': create_date.toIso8601String(),
      'update_date': update_date.toIso8601String(),
      'customer_id': customer_id,
      'payment_method': payment_method_name,
      'customer_address': customer_address.toJson(),
      'order_detail': Order_Detail.toJsonList(order_detail),
    };
  }
}
