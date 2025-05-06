import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String date;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String total;

  final VoidCallback onButtonPressed;
  final String buttonLabel;

  const OrderItem({
    required this.date,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.total,
    required this.onButtonPressed,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 17, 12, 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 32, 32, 32),
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
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white30, thickness: 0.45),
            Row(
              children: [
                Image.network(
                  imageUrl,
                  width: 90,
                  height: 140,
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
                        'Tổng số tiền',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        total,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: onButtonPressed,
                          child: Text(buttonLabel),
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
