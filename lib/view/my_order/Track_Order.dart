import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final String status;

  OrderStatusWidget({super.key, required this.status});

  final List<Map<String, dynamic>> steps = const [
    {'icon': Icons.access_time, 'label': 'Chờ xác nhận'},
    {'icon': Icons.check_circle_outline, 'label': 'Đã xác nhận'},
    {'icon': Icons.local_shipping, 'label': 'Đã giao hàng'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = _getStepFromStatus(status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(steps.length, (index) {
              final isActive = index <= currentStep;
              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor: isActive ? Colors.green : Colors.grey[300],
                    child: Icon(
                      steps[index]['icon'],
                      color: isActive ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[index]['label'],
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            _getStatusText(currentStep),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  int _getStepFromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'chờ xác nhận':
        return 0;
      case 'đã xác nhận':
        return 1;
      case 'đã giao hàng':
        return 2;
      default:
        return 0;
    }
  }

  String _getStatusText(int step) {
    switch (step) {
      case 0:
        return 'Đơn hàng đang chờ xác nhận';
      case 1:
        return 'Đơn hàng đã được xác nhận';
      case 2:
        return 'Đơn hàng đã giao thành công';
      default:
        return '';
    }
  }
}
