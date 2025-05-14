import 'package:fashionshop_app/view/main_screen.dart';
import 'package:fashionshop_app/view/product_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen(), debugShowCheckedModeBanner: false);
  }
}
