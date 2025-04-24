import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Order'),
            actions: [
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
              IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [
                  OrderItem(
                    date: 'TODAY, DEC 22, 2024',
                    imageUrl:
                        'https://photo.znews.vn/w1200/Uploaded/mdf_eioxrd/2021_07_06/1q.jpg',
                    title: 'URBAN BLEND LONG SLEEVE...',
                    subtitle: '+2 other products',
                    total: '441.50\$',
                  ),
                  OrderItem(
                    date: 'TODAY, DEC 24, 2024',
                    imageUrl:
                        'https://nads.1cdn.vn/2024/11/22/e550e6d3-4cbd-4a2d-9975-9107575f9215-2_winnerbird.png',
                    title: 'URBAN BLEND LONG SLEEVE...',
                    subtitle: '+5 other products',
                    total: '441.50\$',
                  ),
                ],
              ),
              ListView(
                children: [
                  OrderItem(
                    date: 'YESTERDAY, DEC 21, 2024',
                    imageUrl:
                        'https://nads.1cdn.vn/2024/11/22/8f881ad1-9014-4e76-8c35-108d36ad9f77-4_winnerwild.png',
                    title: 'URBAN BLEND LONG SLEEVE...',
                    subtitle: '+3 other products',
                    total: '441.50\$',
                  ),
                ],
              ),
              ListView(children: [Text("No orders found")]),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String date;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String total;

  const OrderItem({
    required this.date,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 17, 12, 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 3, 15, 24),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey),
                  onSelected:
                      (value) async => showDialog(
                        context: context,
                        builder: (BuildContext) {
                          return AlertDialog(
                            title: Text("Hủy đơn hàng"),
                            content: Text(
                              "Bạn có chắc chắn muốn hủy đơn hàng này không?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("Không"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  //xử lý hủy đơn hàng ở đây
                                },
                                child: Text("Có"),
                              ),
                            ],
                          );
                        },
                      ),
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Cancel Order',
                          child: Text('Cancel Order'),
                        ),
                      ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Image.network(
                  imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(subtitle, style: TextStyle(color: Colors.grey)),
                      ],
                      SizedBox(height: 8),
                      Text(
                        'TOTAL SHOPPING',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        total,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Track Order'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.green, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
