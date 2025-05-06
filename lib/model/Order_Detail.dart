import 'package:fashionshop_app/model/Product_Info.dart';

class Order_Detail {
  final String? order_detail_id;
  final int? quantity;
  final double? unit_price;
  final String? product_sku_id;
  final String? order_id;
  final Product_Info product_info;

  Order_Detail({
    required this.order_detail_id,
    required this.quantity,
    required this.unit_price,
    required this.product_sku_id,
    required this.order_id,
    required this.product_info,
  });

  factory Order_Detail.fromJson(Map<String, dynamic> json) {
    return Order_Detail(
      order_detail_id: json['order_detail_id'],
      quantity: json['quantity'] ?? 0,
      unit_price: (json['unit_price'] ?? 0 as num).toDouble(),
      product_sku_id: json['product_sku_id'] ?? "",
      order_id: json['order_id'] ?? "",
      product_info: Product_Info.fromJson(json["product_info"]['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_detail_id': order_detail_id,
      'quantity': quantity,
      'unit_price': unit_price,
      'product_sku_id': product_sku_id,
      'order_id': order_id,
      'product_info': product_info.toJson(),
    };
  }

  static List<Order_Detail> fromjsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Order_Detail.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(
    List<Order_Detail> orderDetails,
  ) {
    return orderDetails.map((orderDetail) => orderDetail.toJson()).toList();
  }
}
