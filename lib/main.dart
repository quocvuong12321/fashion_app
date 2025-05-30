import 'package:fashionshop_app/view/main_screen.dart';
import 'package:fashionshop_app/view/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:fashionshop_app/view/main_screen.dart';
import 'package:fashionshop_app/view/auth/sign_in.dart';
import 'package:fashionshop_app/view/auth/sign_up.dart';
import 'package:provider/provider.dart';  
import 'package:fashionshop_app/RequestAPI/request_sign_in.dart';
import 'package:fashionshop_app/RequestAPI/request_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:fashionshop_app/view/home_screen.dart';

void main() {
   debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(
    MultiProvider(
      providers: [
        Provider<RequestSignIn>(create: (_) => RequestSignIn()),
        Provider<RequestSignUp>(create: (_) => RequestSignUp()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
        // '/home': (context) => HomeScreen(),
        '/main_screen': (context) => MainScreen(),  
      },
    );
  }
}

