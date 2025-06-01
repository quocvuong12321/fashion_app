import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/Customer.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../RequestAPI/AuthStorage.dart';
import '../address/manager_address_screen.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, String?>? _cachedUserInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Load cached user data first
    final userInfo = await AuthStorage.getUserInfo();
    setState(() {
      _cachedUserInfo = userInfo;
    });

    // Then try to load fresh profile data
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Use profile data if available, otherwise fall back to auth user data or cached data
    Customer? user = profileProvider.userProfile ?? authProvider.user;

    // If no user data from providers, try to create a Customer from cached data
    if (user == null && _cachedUserInfo != null) {
      try {
        user = Customer(
          customerId: '', // This will be empty as it's not stored in cache
          accountId: '', // Adding the required accountId parameter
          name: _cachedUserInfo!['name'] ?? '',
          email: _cachedUserInfo!['email'] ?? '',
          gender: _cachedUserInfo!['gender'] ?? '',
          dob: DateTime.tryParse(_cachedUserInfo!['dob'] ?? '') ?? DateTime.now(),
          image: _cachedUserInfo!['image'] ?? '',
          createDate: DateTime.now(),
          updateDate: DateTime.now(),
        );
      } catch (e) {
        print('Error creating Customer from cached data: $e');
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: profileProvider.isLoading
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
            onPressed: () {
              // Navigate to login screen - you'll need to implement this
              // Navigator.pushNamed(context, '/login');
            },
            child: const Text("Login Now"),
          )
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
              backgroundColor: Colors.grey.shade200,
              child: user.image.isEmpty ? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Member since: ${_formatDate(user.createDate)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEditProfile(user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _buildMenuItem(
              Icons.location_on,
              "My Addresses",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManagerAddressScreen()),
              ),
            ),
            const Divider(height: 1),
            _buildMenuItem(
              Icons.shopping_bag,
              "My Orders",
              () {
                // Navigate to orders
                // Navigator.pushNamed(context, '/orders');
              },
            ),
            const Divider(height: 1),
            _buildMenuItem(
              Icons.favorite,
              "My Wishlist",
              () {
                // Navigate to wishlist
                // Navigator.pushNamed(context, '/wishlist');
              },
            ),
            const Divider(height: 1),
            _buildMenuItem(
              Icons.settings,
              "Settings",
              () {
                // Navigate to settings
                // Navigator.pushNamed(context, '/settings');
              },
            ),
            const Divider(height: 1),
            _buildMenuItem(
              Icons.logout,
              "Logout",
              _logout,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
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
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: user),
      ),
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    // You might want to navigate to login screen after logout
    // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
