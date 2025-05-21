import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import 'package:fashionshop_app/model/Customer_Address.dart';
import 'package:fashionshop_app/model/Order.dart';
import 'package:fashionshop_app/view/my_order/Track_Order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../RequestAPI/Request_Order.dart';

class Order_Details extends StatefulWidget {
  final Order orderSeleted;
  final Customer_Address customerAddress;
  final String paymentMethod;
  final String discount;
  final String orderStatus;
  const Order_Details({
    super.key,
    required this.orderSeleted,
    required this.customerAddress,
    required this.paymentMethod,
    required this.discount,
    required this.orderStatus,
  });

  @override
  State<Order_Details> createState() => _Order_DetailsState();
}

class _Order_DetailsState extends State<Order_Details> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Chi tiết đơn hàng'),
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [Tab(text: 'Chi tiết'), Tab(text: 'Theo dõi')],
              labelColor: Colors.green[700],
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green[700],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.green[700],
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Địa chỉ giao hàng',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.green[700],
                                          size: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.customerAddress.address,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.green[700],
                                          size: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.customerAddress.phoneNumber,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.green[700],
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Sản phẩm",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      widget.orderSeleted.order_detail.length,
                                  itemBuilder: (context, index) {
                                    final orderDetail =
                                        widget.orderSeleted.order_detail[index];

                                    return Column(
                                      children: [
                                        Divider(
                                          color: Colors.black26,
                                          thickness: 0.45,
                                        ),
                                        Row(
                                          children: [
                                            Image.network(
                                              '${ApiService.UrlHien}media/products?id=${orderDetail.product_info.image}',
                                              width: 90,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    orderDetail
                                                        .product_info
                                                        .name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    orderDetail
                                                        .product_info
                                                        .info_sku_attr,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Số lượng: ${orderDetail.quantity}',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    NumberFormat(
                                                      '0,000đ',
                                                    ).format(
                                                      orderDetail
                                                          .product_info
                                                          .price,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Divider(color: Colors.black26, thickness: 0.45),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Tổng tiền: ${NumberFormat('0,000đ').format(widget.orderSeleted.total_amount)}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      color: Colors.green[700],
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Phương thức thanh toán",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.paymentMethod,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.discount,
                                      color: Colors.green[700],
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Khuyến mãi",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.discount,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        if (widget.orderStatus == 'Chờ Xác Nhận')
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                bool confirm =
                                    await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Xác nhận hủy đơn hàng'),
                                          content: Text(
                                            'Bạn có chắc muốn hủy đơn hàng này không?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                              child: Text('Không'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                              child: Text('Có'),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false;

                                if (confirm) {
                                  await Request_Order.cancelOrder(
                                    widget.orderSeleted.order_id!,
                                    ApiService.token,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đơn hàng đã được hủy.'),
                                    ),
                                  );

                                  Navigator.pop(
                                    context,
                                    true,
                                  ); // Trả kết quả về cho màn trước
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Hủy đơn hàng',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  OrderStatusWidget(status: widget.orderStatus),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
