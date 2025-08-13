import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'MESSAGES',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.textPrimary,
              size: 24,
            ),
            onPressed: () {
              print('Search messages');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          
          // Active Rides Section
          _buildSectionHeader('ACTIVE RIDES'),
          const SizedBox(height: 12),
          
          _buildMessageCard(
            name: 'Maya Rodriguez',
            message: 'See you at the pickup location in 10 minutes!',
            time: '2m ago',
            avatar: 'https://i.pravatar.cc/150?img=1',
            isActive: true,
            rideInfo: 'Rexburg → SLC • Today 3:00 PM',
            unreadCount: 2,
          ),
          
          _buildMessageCard(
            name: 'Connor Smith',
            message: 'Thanks for the ride! Payment sent.',
            time: '1h ago',
            avatar: 'https://i.pravatar.cc/150?img=3',
            isActive: true,
            rideInfo: 'SLC → Rexburg • Tomorrow 7:00 PM',
            unreadCount: 0,
          ),
          
          const SizedBox(height: 24),
          
          // Recent Messages Section
          _buildSectionHeader('RECENT MESSAGES'),
          const SizedBox(height: 12),
          
          _buildMessageCard(
            name: 'Ashley Johnson',
            message: 'Had a great trip! Would definitely ride again.',
            time: '2 days ago',
            avatar: 'https://i.pravatar.cc/150?img=2',
            isActive: false,
            rideInfo: 'Rexburg → SLC • May 14',
            unreadCount: 0,
          ),
          
          _buildMessageCard(
            name: 'Jackson Lee',
            message: 'Can we stop for gas on the way?',
            time: '1 week ago',
            avatar: 'https://i.pravatar.cc/150?img=5',
            isActive: false,
            rideInfo: 'SLC → Rexburg • May 10',
            unreadCount: 0,
          ),
          
          _buildMessageCard(
            name: 'Sam Wilson',
            message: 'Running 5 minutes late, sorry!',
            time: '2 weeks ago',
            avatar: 'https://i.pravatar.cc/150?img=4',
            isActive: false,
            rideInfo: 'Rexburg → Pocatello • May 1',
            unreadCount: 0,
          ),
          
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMessageCard({
    required String name,
    required String message,
    required String time,
    required String avatar,
    required bool isActive,
    required String rideInfo,
    required int unreadCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _openChatScreen(name, rideInfo);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: isActive ? Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        image: DecorationImage(
                          image: NetworkImage(avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isActive)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Message Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Ride Info
                      Text(
                        rideInfo,
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Last Message
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: TextStyle(
                                fontSize: 14,
                                color: unreadCount > 0 
                                    ? AppColors.textPrimary 
                                    : AppColors.textSecondary,
                                fontWeight: unreadCount > 0 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openChatScreen(String name, String rideInfo) {
    // TODO: Navigate to individual chat screen
    print('Opening chat with $name for ride: $rideInfo');
  }
}