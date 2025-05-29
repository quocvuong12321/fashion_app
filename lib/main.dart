import 'package:fashionshop_app/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashionshop_app/view/auth/sign_in.dart';
import 'package:fashionshop_app/view/auth/sign_up.dart';
import 'package:fashionshop_app/RequestAPI/resquest_sign_in.dart';
import 'package:fashionshop_app/RequestAPI/resquest_sign_up.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/profile_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(
          create: (_) => CartProvider()..loadCartFromStorage()),
      Provider<RequestSignIn>(create: (_) => RequestSignIn()),
      Provider<RequestSignUp>(create: (_) => RequestSignUp()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/main_screen': (context) => MainScreen(),
      },
    );
  }
}
