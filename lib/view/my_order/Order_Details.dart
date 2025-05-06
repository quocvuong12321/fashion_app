import 'package:fashionshop_app/RequestAPI/Config.dart';
import 'package:fashionshop_app/model/Customer_Address.dart';
import 'package:fashionshop_app/model/Order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
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
                            color: Color.fromARGB(255, 32, 32, 32),
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
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Địa chỉ giao hàng',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
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
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.customerAddress.address,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
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
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.customerAddress.phoneNumber,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
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
                            color: Color.fromARGB(255, 32, 32, 32),
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
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Sản phẩm",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
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
                                          color: Colors.white30,
                                          thickness: 0.45,
                                        ),
                                        Row(
                                          children: [
                                            Image.network(
                                              '${Config.apiUrlHien}media/products?id=${orderDetail.product_info.image}',
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
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    orderDetail
                                                        .product_info
                                                        .info_sku_attr,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white54,
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
                                                      color: Colors.green,
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
                                Divider(color: Colors.white30, thickness: 0.45),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Tổng số tiền: ${NumberFormat('0,000đ').format(widget.orderSeleted.total_amount)}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.green,
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
                            color: Color.fromARGB(255, 32, 32, 32),
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
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Phương thức thanh toán",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.paymentMethod,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
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
                            color: Color.fromARGB(255, 32, 32, 32),
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
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Khuyến mãi",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.discount,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Text("aaa"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
