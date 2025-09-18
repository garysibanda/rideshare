import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class AddressPickerScreen extends StatefulWidget {
  final String? initialAddress;
  final String title;

  const AddressPickerScreen({
    Key? key,
    this.initialAddress,
    this.title = 'Select Address',
  }) : super(key: key);

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation;
  String? _selectedAddress;
  Set<Marker> _markers = {};
  bool _isLoading = false;
  List<Map<String, dynamic>> _commonLocations = [
    {'name': 'BYU-Idaho Campus', 'address': '525 S Center St, Rexburg, ID 83460', 'lat': 43.8150, 'lng': -111.7849},
    {'name': 'Rexburg Idaho Temple', 'address': '750 S 2nd E, Rexburg, ID 83440', 'lat': 43.8092, 'lng': -111.7777},
    {'name': 'Salt Lake City Airport', 'address': '776 N Terminal Dr, Salt Lake City, UT 84122', 'lat': 40.7899, 'lng': -111.9791},
    {'name': 'Temple Square', 'address': '50 W North Temple, Salt Lake City, UT 84150', 'lat': 40.7707, 'lng': -111.8920},
    {'name': 'University of Utah', 'address': '201 Presidents Cir, Salt Lake City, UT 84112', 'lat': 40.7649, 'lng': -111.8421},
    {'name': 'BYU Provo Campus', 'address': 'Provo, UT 84602', 'lat': 40.2518, 'lng': -111.6493},
    {'name': 'Idaho Falls Regional Airport', 'address': '2140 N Skyline Dr, Idaho Falls, ID 83402', 'lat': 43.5146, 'lng': -112.0707},
    {'name': 'Pocatello Regional Airport', 'address': '1300 Airport Way, Pocatello, ID 83201', 'lat': 42.9098, 'lng': -112.5958},
  ];
  bool _showSuggestions = false;

  // Default location (Rexburg, ID)
  static const LatLng _defaultLocation = LatLng(43.8260, -111.7897);

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null && widget.initialAddress!.isNotEmpty) {
      _searchController.text = widget.initialAddress!;
      _geocodeAddress(widget.initialAddress!);
    } else {
      _selectedLocation = _defaultLocation;
      _updateMarker(_defaultLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search input
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter an address or tap on the map...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
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
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _geocodeAddress(value);
                }
              },
              onChanged: (value) {
                setState(() {
                  _showSuggestions = value.isNotEmpty;
                });
              },
              onTap: () {
                setState(() {
                  _showSuggestions = _searchController.text.isNotEmpty || _commonLocations.isNotEmpty;
                });
              },
            ),
          ),
          
          // Search button
          if (_searchController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _geocodeAddress(_searchController.text),
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text(
                    'Search Address',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Common locations suggestions
          if (_showSuggestions)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Common Locations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  ...(_getFilteredLocations().take(5).map((location) => ListTile(
                    leading: const Icon(Icons.location_on, color: AppColors.primary),
                    title: Text(
                      location['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      location['address'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onTap: () => _selectCommonLocation(location),
                  ))),
                ],
              ),
            ),
          
          // Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? _defaultLocation,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onTap: _onMapTapped,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ),
          
          // Selected address display
          if (_selectedAddress != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Address:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedAddress!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          
          // Confirm button
          Container(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              text: _isLoading ? 'Loading...' : 'Confirm Location',
              onPressed: _selectedLocation != null && !_isLoading ? _confirmSelection : () {},
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng location) async {
    setState(() {
      _isLoading = true;
      _selectedLocation = location;
    });

    _updateMarker(location);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = _formatAddress(placemark);
        
        setState(() {
          _selectedAddress = address;
          _searchController.text = address;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = '${location.latitude}, ${location.longitude}';
        _searchController.text = _selectedAddress!;
        _isLoading = false;
      });
    }
  }

  void _geocodeAddress(String address) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _selectedLocation = location;
          _selectedAddress = address;
          _isLoading = false;
        });
        _updateMarker(location);
        _animateToLocation(location);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: _selectedAddress,
          ),
        ),
      };
    });
  }

  void _animateToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 15),
      ),
    );
  }

  String _formatAddress(Placemark placemark) {
    List<String> addressParts = [];
    
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      addressParts.add(placemark.postalCode!);
    }
    
    return addressParts.join(', ');
  }

  List<Map<String, dynamic>> _getFilteredLocations() {
    if (_searchController.text.isEmpty) {
      return _commonLocations;
    }
    
    final query = _searchController.text.toLowerCase();
    return _commonLocations.where((location) {
      return location['name'].toString().toLowerCase().contains(query) ||
             location['address'].toString().toLowerCase().contains(query);
    }).toList();
  }

  void _selectCommonLocation(Map<String, dynamic> location) {
    final latLng = LatLng(location['lat'], location['lng']);
    setState(() {
      _selectedLocation = latLng;
      _selectedAddress = location['address'];
      _searchController.text = location['address'];
      _showSuggestions = false;
    });
    
    _updateMarker(latLng);
    _animateToLocation(latLng);
  }

  void _confirmSelection() {
    if (_selectedLocation != null && _selectedAddress != null) {
      Navigator.pop(context, {
        'address': _selectedAddress,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
