import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  final String orderStatus;
  const TrackOrder({super.key, required this.orderStatus});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [
          
        ],
      ));
  }
}
