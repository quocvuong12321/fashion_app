import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../model/Customer_Address.dart';

class AddressDetailsScreen extends StatefulWidget {
  final Customer_Address? addressModel;

  const AddressDetailsScreen({Key? key, this.addressModel}) : super(key: key);

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  late final TextEditingController _phoneController;
  late String _fullAddress;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  PhoneNumber? _phoneNumber;

  @override
  void initState() {
    super.initState();

    // Initialize with existing address data or defaults
    _phoneController = TextEditingController(
      text: widget.addressModel?.phoneNumber ?? '+84344197279',
    );
    _fullAddress = widget.addressModel?.address ?? '';

    // Initialize phone number
    _initPhoneNumber();
  }

  void _initPhoneNumber() async {
    try {
      _phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
        _phoneController.text,
      );
      setState(() {});
    } catch (e) {
      // Fallback to default if parsing fails
      _phoneNumber = PhoneNumber(
        phoneNumber: _phoneController.text,
        isoCode: 'VN',
        dialCode: '+84',
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Request location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }

    return true;
  }

  // Get current location and convert to address
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert the coordinates to an address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Format address for Vietnamese style
        setState(() {
          _fullAddress = _formatVietnameseAddress(place);
          _isLoading = false;
        });
      } else {
        setState(() {
          _fullAddress = 'Address not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _fullAddress = 'Error getting location: $e';
        _isLoading = false;
      });
      print('Error getting location: $e');
    }
  }

  String _formatVietnameseAddress(Placemark place) {
    // Format address in Vietnamese style (most specific to least specific)
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }

    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }

    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      addressParts.add(place.subAdministrativeArea!);
    }

    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }

    if (place.country != null &&
        place.country!.isNotEmpty &&
        place.country != "Vietnam") {
      addressParts.add(place.country!);
    }

    return addressParts.join(', ');
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      // Return a map with the necessary information
      Navigator.pop(context, {
        'address': _fullAddress,
        'phoneNumber':
            _phoneNumber?.phoneNumber ?? _phoneController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.addressModel == null ? 'Add New Address' : 'Update Address',
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _buildAddressDisplay(theme),
            const SizedBox(height: 24),
            _buildFormSection(
              title: 'Current Location',
              required: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _fullAddress.isEmpty
                            ? 'Tap refresh to get current location'
                            : _fullAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.green,
                          ),
                        )
                        : IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.green),
                          onPressed: _getCurrentLocation,
                        ),
                  ],
                ),
              ),
            ),
            _buildFormSection(
              title: 'Phone Number',
              required: true,
              child: _buildPhoneInput(theme),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildSaveButton(theme),
      ),
    );
  }

  Widget _buildAddressDisplay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Current Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _fullAddress.isEmpty
                      ? 'Tap refresh to get current location'
                      : _fullAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required Widget child,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildPhoneInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            _phoneNumber = number;
          },
          onInputValidated: (bool value) {
            // Handle validation
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            useBottomSheetSafeArea: true,
            showFlags: true,
            setSelectorButtonAsPrefixIcon: true,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          initialValue: _phoneNumber,
          textFieldController: _phoneController,
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: InputBorder.none,
            hintText: 'Phone number',
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          selectorTextStyle: const TextStyle(color: Colors.black),
          cursorColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _fullAddress.isEmpty ? null : _saveAddress,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Text(
        widget.addressModel == null ? 'Save Address' : 'Update Address',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
