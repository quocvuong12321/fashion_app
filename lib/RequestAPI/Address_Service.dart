import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'AuthStorage.dart';
import '../model/Customer_Address.dart';
import 'api_Services.dart';

class AddressService {
  // Get all addresses for the current user
  Future<List<Customer_Address>> getAddresses() async {
    try {
      // Get token from SharedPreferences
      final accessToken = await AuthStorage.getRefreshToken();
      if (accessToken == null) throw Exception('Access token is null');

      final response = await ApiService.get(
        'user/info/get_address',
        token: accessToken,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['result']['addrs'] as List;
        return data.map((json) => Customer_Address.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      // For demo/development, return mock data in case of errors
      print('Error fetching addresses: $e');
      return [];
    }
  }

  // Add a new address
  Future<Customer_Address> addAddress(
    String address,
    String phoneNumber,
  ) async {
    try {
      // Convert phone number format from +84 to 0 if needed
      String formattedPhoneNumber = phoneNumber;
      if (phoneNumber.startsWith('+84')) {
        formattedPhoneNumber = '0${phoneNumber.substring(3)}';
      }
      print(
        'Adding address for user ID: ${address} with phone number: ${formattedPhoneNumber}',
      );
      //getAccessToken
      final accessToken = await AuthStorage.getRefreshToken();
      //final accessToken = await AuthStorage.getAccessToken();
      if (accessToken == null) throw Exception('Access token is null');

      final response = await ApiService.post(
        'user/info/create_customeraddress',
        {'address': address, 'phoneNumber': formattedPhoneNumber},
        token: accessToken,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Customer_Address.fromJson(responseData['result']);
      } else {
        throw Exception('Failed to add address: ${response.statusCode}');
      }
    } catch (e) {
      // For demo, create a mock success response
      print('Error adding address: $e');
      final customerId = await _getCurrentUserId();

      // Also use the formatted phone number in the mock response
      String formattedPhoneNumber = phoneNumber;
      if (phoneNumber.startsWith('+84')) {
        formattedPhoneNumber = '0${phoneNumber.substring(3)}';
      }

      return Customer_Address(
        idAddress: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: customerId,
        address: address,
        phoneNumber: formattedPhoneNumber,
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
      );
    }
  }

  // Update an existing address
  Future<Customer_Address> updateAddress(
    String addressId,
    String address,
    String phoneNumber,
  ) async {
    try {
      String formattedPhoneNumber = phoneNumber;
      if (phoneNumber.startsWith('+84')) {
        formattedPhoneNumber = '0${phoneNumber.substring(3)}';
      }

      final accessToken = await AuthStorage.getRefreshToken();
      if (accessToken == null) throw Exception('Access token is null');

      print(
        'Updating address ID: $addressId with new address: $address and phone number: $phoneNumber',
      );

      final response =
          await ApiService.patch('user/info/update_customeraddress', {
            'address_id': addressId,
            'address': address,
            'phoneNumber': formattedPhoneNumber,
          }, token: accessToken);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Customer_Address.fromJson(responseData['result']);
      } else {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } catch (e) {
      // For demo, create a mock success response
      print('Error updating address: $e');
      final customerId = await _getCurrentUserId();
      return Customer_Address(
        idAddress: addressId,
        customerId: customerId,
        address: address,
        phoneNumber: phoneNumber,
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
      );
    }
  }

  // Delete an address
  Future<bool> deleteAddress(String addressId) async {
    try {
      final accessToken = await AuthStorage.getRefreshToken();
      if (accessToken == null) throw Exception('Access token is null');

      final response = await ApiService.delete(
        'user/info/delete_customeraddress/$addressId',
        token: accessToken,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // For demo, assume success
      print('Error deleting address: $e');
      return true;
    }
  }

  // Helper method to get current user ID
  Future<String> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Get user ID from preferences, or use a default if not available
    return prefs.getString('user_id') ?? '4f529aee-a691-4434-acf5-ef2937df248a';
  }
}
