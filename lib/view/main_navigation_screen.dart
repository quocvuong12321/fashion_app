import 'package:flutter/material.dart';
import '../view/product_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ProductListScreen(),
    // WishlistScreen(),
    // CartScreen(),
    // MyOrderScreen(),
    // AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF5B895C),
            unselectedItemColor: Colors.black54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Wishlist"),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Cart"),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: "My Order"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Account"),
            ],
          ),
        ),
      ),
    );
  }
}
