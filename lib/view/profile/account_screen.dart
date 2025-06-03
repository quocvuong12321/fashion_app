import 'package:fashionshop_app/view/my_order.dart';
import 'package:fashionshop_app/view/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashionshop_app/RequestAPI/request_sign_in.dart';
import '../../model/Customer.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../RequestAPI/AuthStorage.dart';
import 'package:fashionshop_app/view/auth/sign_in.dart';
import '../address/manager_address_screen.dart';
import 'edit_profile_screen.dart';
import 'package:fashionshop_app/view/auth/update_password.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Color primaryColor = const Color.fromARGB(255, 2, 150, 102);
  Map<String, String?>? _cachedUserInfo;
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final userInfo = await AuthStorage.getUserInfo();
    setState(() {
      _cachedUserInfo = userInfo;
    });

    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    Customer? user = profileProvider.userProfile ?? authProvider.user;

    if (user == null && _cachedUserInfo != null) {
      try {
        user = Customer(
          customerId: '',
          accountId: '',
          name: _cachedUserInfo!['name'] ?? '',
          email: _cachedUserInfo!['email'] ?? '',
          gender: _cachedUserInfo!['gender'] ?? '',
          dob:
              DateTime.tryParse(_cachedUserInfo!['dob'] ?? '') ??
              DateTime.now(),
          image: _cachedUserInfo!['image'] ?? '',
          createDate: DateTime.now(),
          updateDate: DateTime.now(),
        );
      } catch (e) {
        print('Error creating Customer from cached data: $e');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body:
          profileProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : user == null
              ? _buildNotLoggedIn(context)
              : _buildUserProfile(context, user),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You are not logged in",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            child: const Text("Login Now"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, Customer user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 24),
          _buildMenuSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Customer user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  user.image.isNotEmpty ? NetworkImage(user.image) : null,
              backgroundColor: Colors.grey.shade200,
              child:
                  user.image.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Member since: ${_formatDate(user.createDate)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEditProfile(user),
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _buildMenuItem(
              Icons.location_on,
              "My Addresses",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManagerAddressScreen(),
                ),
              ),
            ),
            const Divider(height: 1),
            _buildMenuItem(
              Icons.shopping_bag,
              "My Orders",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOrderScreen()),
              ),
            ),
            const Divider(height: 1),
            _buildMenuItem(
              Icons.favorite,
              "My Wishlist",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductListScreen(categoryId: 'wishlist'),
                ),
              ),
            ),
            _buildMenuItem(Icons.settings, "Change Password", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdatePasswordScreen(),
                ),
              );
            }),

            const Divider(height: 1),
            _buildMenuItem(
              Icons.logout,
              "Logout",
              confirmLogout,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _navigateToEditProfile(Customer user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Hàm xác nhận và xử lý đăng xuất
  Future<void> confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc muốn đăng xuất không?'),
            actions: [
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Đăng xuất'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        isLoggingOut = true;
      });
      final requestSignIn = RequestSignIn();
      final success = await requestSignIn.logout(); // Gọi API đăng xuất

      if (success) {
        setState(() {
          isLoggingOut = false;
          _cachedUserInfo = null;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } else {
        setState(() {
          isLoggingOut = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(requestSignIn.errorMessage)));
      }
    }
  }
}
