import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'PROFILE',
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
            // Profile Card
            _buildProfileCard(),
            
            const SizedBox(height: 32),
            
            // Upcoming Rides Section
            const Text(
              'UPCOMING RIDES',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Rides List
            _buildRideCard(
              from: 'REXBURG',
              to: 'SLC',
              date: 'FRIDAY, MAY 16',
              time: '3PM',
              passengers: ['Maya', 'Ashley', 'Connor'],
              pricePerPerson: 20,
              totalPayout: 60,
              avatars: [
                'https://i.pravatar.cc/150?img=1',
                'https://i.pravatar.cc/150?img=2',
                'https://i.pravatar.cc/150?img=3',
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildRideCard(
              from: 'SLC',
              to: 'REXBURG',
              date: 'SUNDAY, MAY 19',
              time: '7PM',
              passengers: ['Sam', 'Jackson', 'Connor'],
              pricePerPerson: 20,
              totalPayout: 60,
              avatars: [
                'https://i.pravatar.cc/150?img=4',
                'https://i.pravatar.cc/150?img=5',
                'https://i.pravatar.cc/150?img=6',
              ],
            ),
            
            const SizedBox(height: 100), // Extra space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Picture
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=12'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ETHAN CARTER',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'REXBURG, ID',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Rating
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < 5 ? Colors.amber : AppColors.border,
                        )),
                        const SizedBox(width: 8),
                        Text(
                          '5.0 RATING',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Car Info
                    Text(
                      '2020 TOYOTA COROLLA',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  text: 'VIEW EARNINGS',
                  onPressed: () {
                    print('View earnings tapped');
                  },
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  text: 'EDIT PROFILE',
                  onPressed: () {
                    print('Edit profile tapped');
                  },
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.white,
          foregroundColor: isPrimary ? AppColors.white : AppColors.textPrimary,
          elevation: 0,
          side: isPrimary ? null : BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: isPrimary ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRideCard({
    required String from,
    required String to,
    required String date,
    required String time,
    required List<String> passengers,
    required int pricePerPerson,
    required int totalPayout,
    required List<String> avatars,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$from TO $to',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                ),
              ),
              // Passenger Avatars
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 32,
                    child: Stack(
                      children: avatars.asMap().entries.map((entry) {
                        int index = entry.key;
                        String avatar = entry.value;
                        return Positioned(
                          right: index * 20.0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(avatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '$date • $time',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Passenger Info
          Text(
            'PICKING UP ${passengers.join(', ').toUpperCase()}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Price Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$$pricePerPerson/PERSON',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '\$$totalPayout PAYOUT',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              
              // Action Buttons
              Row(
                children: [
                  _buildSmallButton(
                    icon: Icons.message_outlined,
                    onPressed: () {
                      print('Message passengers');
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildSmallButton(
                    icon: Icons.more_vert,
                    onPressed: () {
                      print('More options');
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}