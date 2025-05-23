import 'dart:convert';
import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import '../model/Order.dart';

class Request_Order {
  Request_Order._();

  static Future<List<Order>> fetchOrders(String accessToken) async {
    try {
      final response = await ApiService.get(
        //Ví dụ gọi service api. do dùng baseurl mặc định nên ko cần truyền
        'order/myorder', //đứa nào gọi api của t thì gán baseurl của t là dc: baseUrl = UrlVuong
        token: accessToken,
      );

      final decoded = jsonDecode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final ordersData = decoded['result']?['orders'];
      if (ordersData == null || ordersData is! List) {
        return [];
      }
      return ordersData.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Failed to load orders');
    }
  }

  static Future<String> getImage(String imagePath) async {
    return '${ApiService.UrlHien}media/products?id=$imagePath';
  }

  static Future<void> cancelOrder(String orderId, String accessToken) async {
    try {
      final response = await ApiService.put('order/cancel_order', {
        'order_id': orderId,
      }, token: accessToken);

      if (response.statusCode == 200) {
        print('Order canceled successfully');
      } else {
        print('Failed to cancel order: ${response.body}');
      }
    } catch (e) {
      print('Error canceling order: $e');
    }
  }

  static Future<bool> feedBack(
    List<String> productsSpuId,
    String comment,
    int star,
    String accessToken,
  ) async {
    try {
      for (int i = 0; i < productsSpuId.length; i++) {
        final response = await ApiService.post('rating/auth/create', {
          'products_spu_id': productsSpuId[i],
          'comment': comment,
          'star': star,
        }, token: accessToken);
        if (response.statusCode == 200) {
          print('Feedback submitted successfully');
        } else {
          print('Failed to submit feedback: ${response.body}');
          return false;
        }
      }
      return true;
    } catch (e) {
      print('Error submitting feedback: $e');
      return false;
    }
  }
}
