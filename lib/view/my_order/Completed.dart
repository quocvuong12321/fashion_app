import 'package:fashionshop_app/RequestAPI/Request_Order.dart';
import 'package:fashionshop_app/model/Order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'OrderItem.dart';

class Completed extends StatefulWidget {
  final List<Order> orders;
  const Completed({super.key, required this.orders});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
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
          total: "${order.total_amount} đ",
          onButtonPressed: () => {},
          buttonLabel: "Leave feedback",
        );
      },
    );
  }
}
