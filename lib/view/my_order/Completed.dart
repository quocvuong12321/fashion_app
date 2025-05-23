import 'package:fashionshop_app/model/Order.dart';
import 'package:fashionshop_app/view/my_order/Feedback.dart';
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
          imageUrl: order.order_detail[0].product_info.image,
          title: order.order_detail[0].product_info.name,
          subtitle:
              order.order_detail.length > 1
                  ? "+${order.order_detail.length - 1} order products"
                  : "",
          total: NumberFormat('#,### đ').format(order.total_amount),
          onButtonPressed: () {
            final List<String> spuId = [];
            for (var i = 0; i < order.order_detail.length; i++) {
              spuId.add(order.order_detail[i].product_info.products_spu_id);
            }
            showDialog(
              context: context,
              builder: (context) => FeedbackForm(productsSpuId: spuId),
            );
          },
          buttonLabel: "Đánh giá",
        );
      },
    );
  }
}
