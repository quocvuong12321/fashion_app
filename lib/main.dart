import 'dart:async';

import 'package:fashionshop_app/view/main_screen.dart';
import 'package:fashionshop_app/view/product_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   StreamSubscription? _sub;

//   @override
//   void initState() {
//     super.initState();
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri != null) {
//         // Xử lý deeplink ở đây, ví dụ chuyển trang
//         print('Deeplink: $uri');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MainScreen(), debugShowCheckedModeBanner: false);
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen(), debugShowCheckedModeBanner: false);
  }
}
