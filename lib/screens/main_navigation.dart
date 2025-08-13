import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/app_colors.dart';
import 'home/home_screen.dart';
import 'rides/post_ride_screen.dart';
import 'profile/profile_screen.dart';
import 'messages/messages_screen.dart';
import 'search/search_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),           // Index 0: Home
    const SearchScreen(),         // Index 1: Search  
    const PostRideScreen(),       // Index 2: Plus button
    const MessagesScreen(),       // Index 3: Messages
    const ProfileScreen(),        // Index 4: Profile
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}

// No more placeholder classes - all screens are imported from separate files