import 'package:flutter/material.dart';

import '../../RequestAPI/Address_Service.dart';
import '../../model/Customer_Address.dart';
import 'address_detail_screen.dart';

class ManagerAddressScreen extends StatefulWidget {
  const ManagerAddressScreen({super.key});

  @override
  State<ManagerAddressScreen> createState() => _ManagerAddressScreenState();
}

class _ManagerAddressScreenState extends State<ManagerAddressScreen> {
  final AddressService _addressService = AddressService();
  List<Customer_Address> _addresses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final addresses = await _addressService.getAddresses();
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load addresses: $e';
        _isLoading = false;
      });
    }
  }

  void _addNewAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressDetailsScreen(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() => _isLoading = true);

      try {
        final newAddress = await _addressService.addAddress(
          result['address']!,
          result['phoneNumber']!,
        );

        setState(() {
          _addresses.add(newAddress);
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully')),
        );
      } catch (e) {
        setState(() {
          _error = 'Failed to add address: $e';
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $_error')),
        );
      }
    }
  }

  void _editAddress(Customer_Address address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressDetailsScreen(
          addressModel: address,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() => _isLoading = true);

      try {
        final updatedAddress = await _addressService.updateAddress(
          address.idAddress,
          result['address']!,
          result['phoneNumber']!,
        );

        setState(() {
          final index = _addresses
              .indexWhere((a) => a.idAddress == updatedAddress.idAddress);
          if (index != -1) {
            _addresses[index] = updatedAddress;
          }
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address updated successfully')),
        );
      } catch (e) {
        setState(() {
          _error = 'Failed to update address: $e';
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $_error')),
        );
      }
    }
  }

  void _showMoreOptions(Customer_Address address) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete Address'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteAddress(address);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteAddress(Customer_Address address) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      try {
        final success = await _addressService.deleteAddress(address.idAddress);

        if (success) {
          setState(() {
            _addresses.removeWhere((a) => a.idAddress == address.idAddress);
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address deleted successfully')),
          );
        }
      } catch (e) {
        setState(() {
          _error = 'Failed to delete address: $e';
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $_error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Manage Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewAddress,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAddresses,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAddresses,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : _addresses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No saved locations yet',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _addNewAddress,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Add New Address'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _addresses.length,
                        itemBuilder: (context, index) {
                          final address = _addresses[index];
                          return AddressCard(
                            addressModel: address,
                            onChangeAddress: () => _editAddress(address),
                            onMoreOptions: () => _showMoreOptions(address),
                          );
                        },
                      ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final Customer_Address addressModel;
  final VoidCallback onChangeAddress;
  final VoidCallback onMoreOptions;

  const AddressCard({
    Key? key,
    required this.addressModel,
    required this.onChangeAddress,
    required this.onMoreOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // icon share
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Implement share functionality here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  addressModel.address,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      addressModel.phoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onChangeAddress,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Change Address'),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: onMoreOptions,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
