import 'package:fashionshop_app/view/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import 'provider/product_detail_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductListScreen(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListScreen(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}
