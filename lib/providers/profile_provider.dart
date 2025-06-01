import 'package:flutter/foundation.dart';

import '../RequestAPI/profile_service.dart';
import '../model/Customer.dart';
import '../model/Customer_Address.dart';
 
class ProfileProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = false;
  String? _errorMessage;
  Customer? _userProfile;
  List<Customer_Address> _addresses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Customer? get userProfile => _userProfile;
  List<Customer_Address> get addresses => _addresses;

  // Load user profile
  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final profile = await _profileService.getUserProfile();
      print("profile = $profile");
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load user addresses
  Future<void> loadUserAddresses() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final addresses = await _profileService.getUserAddresses();
      _addresses = addresses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new address
  Future<bool> addAddress(String address, String phoneNumber) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newAddress = await _profileService.addAddress(address, phoneNumber);
      _addresses.add(newAddress);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update an existing address
  Future<bool> updateAddress(String addressId, String address, String phoneNumber) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedAddress = await _profileService.updateAddress(addressId, address, phoneNumber);
      
      final index = _addresses.indexWhere((a) => a.idAddress == addressId);
      if (index >= 0) {
        _addresses[index] = updatedAddress;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete an address
  Future<bool> deleteAddress(String addressId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _profileService.deleteAddress(addressId);
      
      if (success) {
        _addresses.removeWhere((a) => a.idAddress == addressId);
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
