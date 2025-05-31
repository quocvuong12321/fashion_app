import 'package:fashionshop_app/RequestAPI/auth_guard.dart';
import 'package:fashionshop_app/view/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_order.dart';
import 'product_list_screen.dart';
import 'package:fashionshop_app/view/auth/sign_up.dart';
import 'package:fashionshop_app/view/auth/sign_in.dart';
import 'package:fashionshop_app/RequestAPI/request_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:fashionshop_app/view/home_screen.dart';
import 'package:fashionshop_app/RequestAPI/request_sign_in.dart';

void main() {
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
      home: MainScreen(),
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/main_screen': (context) => MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _selectedCategoryId = '12';

  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    ProductListScreen(categoryId: '12'),
    CartScreen(),
    AuthGuard(child: MyOrderScreen()),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _screens[1] = ProductListScreen(categoryId: _selectedCategoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'List'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'My Order'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// HomeScreen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home_Screen();
  }
}

// CartScreen
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Center(child: Text('Your Cart')),
    );
  }
}

// AccountScreen
class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Account_Screen());
  }
}
