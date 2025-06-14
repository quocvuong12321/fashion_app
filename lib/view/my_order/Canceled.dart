import 'package:fashionshop_app/RequestAPI/auth_guard.dart';
import 'package:fashionshop_app/model/Order.dart';
import 'package:fashionshop_app/model/Product_In_pay.dart';
import 'package:fashionshop_app/view/my_order/OrderItem.dart';
import 'package:fashionshop_app/view/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Canceled extends StatefulWidget {
  final List<Order> orders;
  const Canceled({super.key, required this.orders});

  @override
  State<Canceled> createState() => _CanceledState();
}

class _CanceledState extends State<Canceled> {
  void handleDatlai(int index) {
    List<Products_In_pay> productPay = [];
    for (var element in widget.orders[index].order_detail) {
      productPay.add(
        Products_In_pay(
          productsSpuId: element.order_detail_id!,
          name: element.product_info.name,
          image: element.product_info.image,
          productSkuId: element.product_sku_id!,
          amount: element.quantity!,
          price: double.parse(element.product_info.price.toString()),
          key: element.order_detail_id! + element.product_sku_id!,
          skuString: element.product_info.info_sku_attr,
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AuthGuard(
              child: PaymentScreen(products: productPay, inCard: true),
            ),
      ),
    );
  }

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
          total: NumberFormat('0,000 đ').format(order.total_amount),
          onButtonPressed: () {
            handleDatlai(index);
          },
          buttonLabel: "Mua lại",
          paymentStatus: order.payment_status,
        );
      },
    );
  }
}
