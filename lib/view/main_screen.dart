import 'package:flutter/material.dart';

import '../utils/navigation_utils.dart';
import 'cart_screen.dart';
import 'my_order.dart';
import 'product_list_screen.dart';
import 'profile/account_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Demo',
      theme: ThemeData.light(),
      home: MainScreen(),
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

  @override
  void initState() {
    super.initState();
    // Register the tab setter function
    NavigationUtils.setMainTabSetter((index) {
      setState(() {
        _selectedIndex = index;
      });
    });
  }

  // Danh sách các màn hình tương ứng với từng tab
  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    ProductListScreen(categoryId: '12'),
    CartScreen(),
    MyOrderScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // Nếu chọn tab "List", truyền categoryId vào ProductListScreen
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

// Các màn hình đơn giản cho từng tab
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome to Home Screen')),
    );
  }
}

// class MyOrderScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Order')),
//       body: Center(child: Text('Your Orders')),
//     );
//   }
// }

 