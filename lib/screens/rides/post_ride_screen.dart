import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import './address_picker_screen.dart';

class PostRideScreen extends StatefulWidget {
  const PostRideScreen({Key? key}) : super(key: key);

  @override
  State<PostRideScreen> createState() => _PostRideScreenState();
}

class _PostRideScreenState extends State<PostRideScreen> {
  String _fromLocation = 'Select pickup location';
  double? _fromLatitude;
  double? _fromLongitude;
  String _toLocation = 'SLC';
  DateTime _selectedDate = DateTime(2025, 5, 23);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  int _seatCount = 3;
  double _price = 25.0;
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text = _price.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'POST A RIDE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From and To Location
            Row(
              children: [
                Expanded(
                  child: _buildFromLocationInput(),
                ),
                const SizedBox(width: 16),
                // Swap icon
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.swap_horiz,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLocationSelector(
                    label: 'TO:',
                    value: _toLocation,
                    onTap: () => _showLocationPicker(false),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Date and Time
            const Text(
              'DATE:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildDateTimeButton(
                    text: _formatDate(_selectedDate),
                    onTap: _selectDate,
                    isBlue: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateTimeButton(
                    text: _formatTime(_selectedTime),
                    onTap: _selectTime,
                    isBlue: true,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seat Count
            const Text(
              'HOW MANY SEATS?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                _buildSeatCounter(),
                const SizedBox(width: 16),
                _buildCounterButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _seatCount++),
                ),
                const SizedBox(width: 12),
                _buildCounterButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (_seatCount > 1) {
                      setState(() => _seatCount--);
                    }
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Price
            const Text(
              'WHAT IS YOUR PRICE?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                _buildPriceInput(),
                const SizedBox(width: 16),
                Text(
                  'ONE WAY',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            
            // Post Ride Button
            CustomButton(
              text: 'POST YOUR RIDE',
              onPressed: _postRide,
              backgroundColor: AppColors.primary,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFromLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FROM:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openAddressPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _fromLocation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _fromLocation == 'Select pickup location' 
                          ? AppColors.textSecondary 
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSelector({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeButton({
    required String text,
    required VoidCallback onTap,
    bool isBlue = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBlue ? AppColors.primary.withOpacity(0.1) : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isBlue ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$_seatCount',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPriceInput() {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixText: '\$',
          prefixStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        onChanged: (value) {
          final newPrice = double.tryParse(value);
          if (newPrice != null && newPrice > 0) {
            setState(() {
              _price = newPrice;
            });
          }
        },
      ),
    );
  }

  void _openAddressPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddressPickerScreen(
          initialAddress: _fromLocation != 'Select pickup location' ? _fromLocation : null,
          title: 'Select Pickup Location',
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _fromLocation = result['address'] as String;
        _fromLatitude = result['latitude'] as double;
        _fromLongitude = result['longitude'] as double;
      });
    }
  }

  void _showLocationPicker(bool isFrom) {
    final locations = ['REXBURG', 'SLC', 'POCATELLO', 'IDAHO FALLS', 'PROVO', 'BOISE'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isFrom ? 'Select From Location' : 'Select To Location',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ...locations.map((location) => ListTile(
              title: Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    _fromLocation = location;
                  } else {
                    _toLocation = location;
                  }
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  void _postRide() {
    // Create JSON schema matching backend format exactly
    final rideData = {
      "startlocation": {
        "coordinates": _getCoordinatesString(_fromLocation),
        "address": {
          "line1": _fromLatitude != null ? _fromLocation.split(',').first : "", // Use actual address
          "line2": "", // Will be filled by Google Maps API  
          "city": _getCity(_fromLocation),
          "state": _getStateForCity(_fromLocation),
          "zip": "" // Will be filled by Google Maps API
        }
      },
      "endLocation": {
        "coordinates": _getCoordinatesString(_toLocation),
        "address": {
          "line1": "", // Will be filled by Google Maps API
          "line2": "", // Will be filled by Google Maps API
          "city": _toLocation,
          "state": _getStateForCity(_toLocation),
          "zip": "" // Will be filled by Google Maps API
        }
      },
      "customRadius": 10.0, // Default radius in miles/km
      "tripTime": _getTripTimeString()
    };

    // Convert to JSON string
    final jsonString = jsonEncode(rideData);
    
    print('=== POST RIDE JSON FOR BACKEND (Schema 1.1.1.6.5) ===');
    print(jsonString);
    print('=== END JSON ===');
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ride posted successfully! Check console for JSON.'),
        backgroundColor: AppColors.primary,
      ),
    );
    
    // TODO: Send to backend API
    // _sendToBackend(rideData);
  }

  // Helper function to get coordinates as string format
  String _getCoordinatesString(String city) {
    // If we have coordinates from the address picker, use those
    if (_fromLatitude != null && _fromLongitude != null && city == _fromLocation) {
      return '$_fromLatitude,$_fromLongitude';
    }
    
    // Fallback to hardcoded coordinates for predefined cities
    final coordinates = {
      'REXBURG': '43.8260,-111.7897',
      'SLC': '40.7608,-111.8910',
      'POCATELLO': '42.8746,-112.4455',
      'IDAHO FALLS': '43.4666,-112.0340',
      'PROVO': '40.2338,-111.6585',
      'BOISE': '43.6150,-116.2023',
    };
    
    return coordinates[city] ?? '0.0,0.0';
  }

  // Helper function to extract city from address
  String _getCity(String address) {
    // If it's a full address, try to extract city (usually after the first comma)
    if (_fromLatitude != null && address.contains(',')) {
      final parts = address.split(',');
      if (parts.length >= 2) {
        return parts[1].trim();
      }
    }
    
    // Fallback to the address itself or empty string
    return address.replaceAll('Select pickup location', '');
  }

  // Helper function to get state abbreviation
  String _getStateForCity(String city) {
    final cityStates = {
      'REXBURG': 'ID',
      'SLC': 'UT', 
      'POCATELLO': 'ID',
      'IDAHO FALLS': 'ID',
      'PROVO': 'UT',
      'BOISE': 'ID',
    };
    
    return cityStates[city] ?? 'ID';
  }

  // Helper function to format trip time as ISO string
  String _getTripTimeString() {
    final tripDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    
    return tripDateTime.toIso8601String();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }
}