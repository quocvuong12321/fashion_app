import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'my_order/Active.dart';
import 'my_order/Completed.dart';
import 'my_order/Canceled.dart';
import '../model/Order.dart';
import '../RequestAPI/Request_Order.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late Future<List<Order>> futureOrders;
  late Future<Uint8List?> futureImage;
  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    futureOrders = Request_Order.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allOrders = snapshot.data!;

            // Tùy loại bạn lọc ra các danh sách riêng
            final activeOrders =
                allOrders
                    .where(
                      (e) =>
                          e.order_status == 'Chờ Xác Nhận' ||
                          e.order_status == 'Đã Xác Nhận',
                    )
                    .toList();
            activeOrders.sort((a, b) => a.create_date.compareTo(b.create_date));
            final completedOrders =
                allOrders
                    .where((e) => e.order_status == 'Đã Giao Hàng')
                    .toList();
            completedOrders.sort(
              (a, b) => a.create_date.compareTo(b.create_date),
            );
            final canceledOrders =
                allOrders.where((e) => e.order_status == 'Đã Hủy').toList();
            canceledOrders.sort(
              (a, b) => a.create_date.compareTo(b.create_date),
            );

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('My Order'),

                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'Đã đặt'),
                      Tab(text: 'Đã giao hàng'),
                      Tab(text: 'Đã hủy'),
                    ],
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.green,
                  ),
                ),
                body: TabBarView(
                  children: [
                    Active(
                      orders: activeOrders,
                      onOrderChanged: () {
                        setState(() {
                          loadOrders(); // Reload đơn hàng khi có thay đổi
                        });
                      },
                    ),
                    Completed(orders: completedOrders),
                    Canceled(orders: canceledOrders),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print("Lỗi: ${snapshot.error}");
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
