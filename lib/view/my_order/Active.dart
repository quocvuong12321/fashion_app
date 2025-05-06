import 'package:fashionshop_app/RequestAPI/Config.dart';
import 'package:fashionshop_app/view/my_order/Order_Details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'OrderItem.dart';
import '../../model/Order.dart';

class Active extends StatefulWidget {
  final List<Order> orders;
  const Active({super.key, required this.orders});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final order = widget.orders[index];
        return OrderItem(
          date: DateFormat('dd/MM/yyyy HH:mm:ss').format(order.create_date),
          imageUrl:
              '${Config.apiUrlHien}media/products?id=${order.order_detail[0].product_info.image}',
          title: order.order_detail[0].product_info.name,
          subtitle:
              order.order_detail.length > 1
                  ? "+${order.order_detail.length - 1} sản phẩm khác"
                  : "",
          total: NumberFormat('0,000đ').format(order.total_amount),
          onButtonPressed:
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Order_Details(
                        orderSeleted: order,
                        customerAddress: order.customer_address,
                        paymentMethod: order.payment_method_name!,
                        discount: order.discount_id!,
                        orderStatus: order.order_status!,
                      );
                    },
                  ),
                ),
              },
          buttonLabel: "Xem chi tiết",
        );
      },
    );
  }
}
