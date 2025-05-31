import 'package:fashionshop_app/RequestAPI/Request_Order.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String date;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String total;
  final VoidCallback onButtonPressed;
  final String buttonLabel;
  final String? status;
  const OrderItem({
    required this.date,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.total,
    required this.onButtonPressed,
    required this.buttonLabel,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 17, 12, 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 245),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateRow(),
            SizedBox(height: 10),
            Divider(color: Colors.black12, thickness: 0.45),
            Row(
              children: [
                _buildProductImage(),
                SizedBox(width: 16),
                _buildProductDetails(),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Row _buildDateRow() {
    return Row(
      children: [
        Icon(Icons.shopping_bag_outlined, color: Colors.green, size: 25),
        SizedBox(width: 8),
        Text(date, style: TextStyle(fontSize: 12, color: Colors.grey)),
        Spacer(),
        status != null
            ? Text(status!, style: TextStyle(fontSize: 12, color: Colors.grey))
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildProductImage() {
    return FutureBuilder<String>(
      future: Request_Order.fgetImage(imageUrl), // Gọi hàm lấy URL ảnh
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Chờ khi tải ảnh
        } else if (snapshot.hasError) {
          return Icon(
            Icons.error,
            color: Colors.red,
          ); // Nếu có lỗi, hiển thị lỗi
        } else if (snapshot.hasData) {
          return Image.network(
            snapshot.data!, // Hiển thị ảnh khi đã có dữ liệu
            width: 90,
            height: 140,
            fit: BoxFit.cover,
          );
        } else {
          return Icon(Icons.error, color: Colors.red); // Nếu không có dữ liệu
        }
      },
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey)),
          ],
          SizedBox(height: 8),
          _buildTotalAmount(),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tổng số tiền', style: TextStyle(color: Colors.grey)),
        Text(
          total,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onButtonPressed,
        child: Text(buttonLabel),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.green, width: 1),
          ),
        ),
      ),
    );
  }
}
