import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              index: 0,
              isActive: currentIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.search_outlined,
              activeIcon: Icons.search,
              index: 1,
              isActive: currentIndex == 1,
            ),
            _buildPlusButton(),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              activeIcon: Icons.chat_bubble,
              index: 3,
              isActive: currentIndex == 3,
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              index: 4,
              isActive: currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Icon(
          isActive ? activeIcon : icon,
          size: 28,
          color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPlusButton() {
    return GestureDetector(
      onTap: () => onTap(2), // Index 2 for the plus button
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Icon(
          Icons.add,
          size: 28,
          color: AppColors.white,
        ),
      ),
    );
  }
}