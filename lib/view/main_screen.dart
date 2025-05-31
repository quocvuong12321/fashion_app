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
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bottom Navigation Demo',
//       theme: ThemeData.light(),
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   String _selectedCategoryId = '12';

//   // Danh sách các màn hình tương ứng với từng tab
//   static final List<Widget> _screens = <Widget>[
//     HomeScreen(),
//     ProductListScreen(categoryId: '12'),
//     CartScreen(),
//     MyOrderScreen(),
//     AccountScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       if (index == 1) {
//         // Nếu chọn tab "List", truyền categoryId vào ProductListScreen
//         _screens[1] = ProductListScreen(categoryId: _selectedCategoryId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'List'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'My Order'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// // Các màn hình đơn giản cho từng tab
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Center(child: Text('Welcome to Home Screen')),
//     );
//   }
// }

// // class ProductListScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Danh Sách Sản Phẩm")),
// //       body: Center(child: Text("Hiển thị danh sách sản phẩm ở đây")),
// //     );
// //   }
// // }

// class CartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Cart')),
//       body: Center(child: Text('Your Cart')),
//     );
//   }
// }

// // class MyOrderScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('My Order')),
// //       body: Center(child: Text('Your Orders')),
// //     );
// //   }
// // }

// class AccountScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Account')),
//       body: Center(child: Text('Account Details')),

//     );
//   }
// }

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
      home: SignInScreen(), // Màn hình khởi đầu là đăng nhập
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
    MyOrderScreen(),
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
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Scaffold(body: Home_Screen()),
    );
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
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Center(child: Text('Account Details')),
    );
  }
}
