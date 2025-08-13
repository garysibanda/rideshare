import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _fromLocation = 'REXBURG';
  String _toLocation = 'SLC';
  DateTime _selectedDate = DateTime.now();
  int _passengerCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'FIND A RIDE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Form
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From and To Location
                Row(
                  children: [
                    Expanded(
                      child: _buildLocationSelector(
                        label: 'FROM:',
                        value: _fromLocation,
                        onTap: () => _showLocationPicker(true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Swap icon
                    GestureDetector(
                      onTap: _swapLocations,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.swap_horiz,
                          color: AppColors.primary,
                          size: 24,
                        ),
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
                
                const SizedBox(height: 24),
                
                // Date and Passengers
                Row(
                  children: [
                    Expanded(
                      child: _buildDateSelector(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPassengerSelector(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Search Button
                CustomButton(
                  text: 'SEARCH RIDES',
                  onPressed: _searchRides,
                  backgroundColor: AppColors.primary,
                ),
              ],
            ),
          ),
          
          // Search Results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
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

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DATE:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
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
                  _formatDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PASSENGERS:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_passengerCount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_passengerCount > 1) {
                        setState(() => _passengerCount--);
                      }
                    },
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => _passengerCount++);
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVAILABLE RIDES',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView(
              children: [
                _buildRideCard(
                  driverName: 'Sarah Johnson',
                  driverRating: 4.9,
                  carInfo: '2022 Honda Civic',
                  departureTime: '3:00 PM',
                  availableSeats: 3,
                  price: 25,
                  avatar: 'https://i.pravatar.cc/150?img=8',
                ),
                
                _buildRideCard(
                  driverName: 'Mike Chen',
                  driverRating: 4.8,
                  carInfo: '2021 Toyota Camry',
                  departureTime: '5:30 PM',
                  availableSeats: 2,
                  price: 30,
                  avatar: 'https://i.pravatar.cc/150?img=7',
                ),
                
                _buildRideCard(
                  driverName: 'Emma Wilson',
                  driverRating: 5.0,
                  carInfo: '2020 Subaru Outback',
                  departureTime: '7:00 PM',
                  availableSeats: 1,
                  price: 22,
                  avatar: 'https://i.pravatar.cc/150?img=9',
                ),
                
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard({
    required String driverName,
    required double driverRating,
    required String carInfo,
    required String departureTime,
    required int availableSeats,
    required int price,
    required String avatar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Driver Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: NetworkImage(avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Driver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                          Icons.star,
                          size: 14,
                          color: index < driverRating.floor() 
                              ? Colors.amber 
                              : AppColors.border,
                        )),
                        const SizedBox(width: 6),
                        Text(
                          '$driverRating',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      carInfo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$$price',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'per person',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Trip Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTripDetail(
                icon: Icons.schedule,
                text: departureTime,
              ),
              _buildTripDetail(
                icon: Icons.people,
                text: '$availableSeats seats',
              ),
              _buildTripDetail(
                icon: Icons.route,
                text: '$_fromLocation → $_toLocation',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Book Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => _bookRide(driverName, price),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text(
                'BOOK RIDE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
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

  void _swapLocations() {
    setState(() {
      final temp = _fromLocation;
      _fromLocation = _toLocation;
      _toLocation = temp;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  void _searchRides() {
    print('Searching rides:');
    print('From: $_fromLocation');
    print('To: $_toLocation');
    print('Date: ${_formatDate(_selectedDate)}');
    print('Passengers: $_passengerCount');
    
    // In a real app, this would trigger the API call and update results
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Searching for available rides...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _bookRide(String driverName, int price) {
    print('Booking ride with $driverName for \$$price');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ride with $driverName...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}