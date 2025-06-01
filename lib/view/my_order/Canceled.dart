import 'package:fashionshop_app/model/Order.dart';
import 'package:fashionshop_app/view/my_order/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Canceled extends StatefulWidget {
  final List<Order> orders;
  const Canceled({super.key, required this.orders});

  @override
  State<Canceled> createState() => _CanceledState();
}

class _CanceledState extends State<Canceled> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final order = widget.orders[index];
        return OrderItem(
          date: DateFormat('dd/MM/yyyy HH:mm:ss').format(order.create_date),
          imageUrl: order.order_detail[index].product_info.image,
          title: order.order_detail[index].product_info.name,
          subtitle:
              order.order_detail.length > 1
                  ? "+${order.order_detail.length - 1} order products"
                  : "",
          total: NumberFormat('0,000 đ').format(order.total_amount),
          onButtonPressed: () => {},
          buttonLabel: "Mua lại",
          paymentStatus: order.payment_status,
        );
      },
    );
  }
}
