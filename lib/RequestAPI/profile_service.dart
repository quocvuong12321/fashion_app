import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../RequestAPI/api_Services.dart';
import '../model/Customer.dart';
import '../model/Customer_Address.dart';
import 'Address_Service.dart';
import 'package:fashionshop_app/RequestAPI/AuthStorage.dart';

class ProfileService {
  final AddressService _addressService = AddressService();

  Future<Customer?> getUserProfile() async {
    try {
      //
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final userId = prefs.getString('user_id') ?? '';

      if (userId.isEmpty || token.isEmpty) {
        return null;
      }

      final response = await ApiService.get(
        'user/info/get_customer/$userId',
        token: token,
      );

      final storedUsername = await AuthStorage.getUsername();
      final userInfo = await AuthStorage.getUserInfo();
      //
      //       if (response.statusCode == 200) {
      //         final jsonResponse = jsonDecode(response.body);
      return Customer(
        customerId: "",
        name: userInfo['name'] ?? "",
        email: userInfo['email'] ?? "",
        image: userInfo['image'] ?? "",
        dob: DateTime.now(),
        gender: userInfo['gender'] ?? "",
        accountId: "",
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
      );
      //       } else {
      //         throw Exception('Failed to get user profile: ${response.statusCode}');
      //       }
    } catch (e) {
      print('Error getting user profile: $e');
      // Try to get from shared preferences as fallback
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return Customer.fromJson(jsonDecode(userData));
      }
      return null;
    }
  }

  // Method to update user profile
  // Future<bool> updateUserProfile({
  //   required String name,
  //   required String email,
  //   required String gender,
  //   required String dob,
  //   String? image,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token') ?? '';
  //     if (token.isEmpty) return false;

  //     final body = {'name': name, 'email': email, 'gender': gender, 'dob': dob};
  //     if (image != null) body['image'] = image;

  //     final response = await ApiService.patch(
  //       'user/info/update_customer',
  //       body,
  //       token: token,
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       print('Update profile failed: ${response.body}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error updating profile: $e');
  //     return false;
  //   }
  // }

  // Method to get all addresses for the current user
  Future<List<Customer_Address>> getUserAddresses() async {
    return await _addressService.getAddresses();
  }

  // Method to add a new address
  Future<Customer_Address> addAddress(
    String address,
    String phoneNumber,
  ) async {
    return await _addressService.addAddress(address, phoneNumber);
  }

  // Method to update an address
  Future<Customer_Address> updateAddress(
    String addressId,
    String address,
    String phoneNumber,
  ) async {
    return await _addressService.updateAddress(addressId, address, phoneNumber);
  }

  // Method to delete an address
  Future<bool> deleteAddress(String addressId) async {
    return await _addressService.deleteAddress(addressId);
  }
}
