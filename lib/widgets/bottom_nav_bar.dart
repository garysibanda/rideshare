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
      child: Stack(
        children: [
          // Custom shaped background
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: BottomNavPainter(),
          ),
          
          // Navigation items in normal row layout
          SafeArea(
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
        ],
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
          color: Colors.black, // Changed to black for all icons
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

// Custom painter for the bottom navigation bar with pill-shaped bump
class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.primary  // Changed to blue accent color
      ..style = PaintingStyle.fill;

    Path path = Path();
    
    // Start from bottom left
    path.moveTo(0, size.height);
    
    // Draw up the left side to normal nav bar height
    path.lineTo(0, 0);
    
    // Draw straight line to start of pill bump
    double pillStart = size.width / 2 - 50; // Start of pill shape
    path.lineTo(pillStart, 0);
    
    // Create pill-shaped bump that curves upward (above the normal bar level)
    path.quadraticBezierTo(
      pillStart + 15, -15,      // Control point - curve up above bar
      pillStart + 25, -15,      // Start of flat top section
    );
    
    // Flat top section of the pill
    double pillEnd = size.width / 2 + 50;
    path.lineTo(pillEnd - 25, -15);  // Straight line across top of pill
    
    // End curve of the pill
    path.quadraticBezierTo(
      pillEnd - 15, -15,        // Control point
      pillEnd, 0,               // Back down to normal height
    );
    
    // Continue straight to right edge
    path.lineTo(size.width, 0);
    
    // Down the right side
    path.lineTo(size.width, size.height);
    
    // Close the path along the bottom
    path.close();

    canvas.drawPath(path, paint);
    
    // Draw subtle border with white for contrast on blue background
    Paint borderPaint = Paint()
      ..color = AppColors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // Only draw the top border (the curved part)
    Path borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(pillStart, 0);
    borderPath.quadraticBezierTo(pillStart + 15, -15, pillStart + 25, -15);
    borderPath.lineTo(pillEnd - 25, -15);
    borderPath.quadraticBezierTo(pillEnd - 15, -15, pillEnd, 0);
    borderPath.lineTo(size.width, 0);
    
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}