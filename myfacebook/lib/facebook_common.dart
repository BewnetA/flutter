// facebook_common.dart
import 'package:flutter/material.dart';

class FacebookCommon {
  // Common Facebook header with Facebook text on left and menu icon on right
  static Widget buildFacebookHeader({bool showSearch = true}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Facebook text logo on left
          const Text(
            'facebook',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1877F2),
            ),
          ),
          
          const Spacer(),
          
          // Search icon (optional)
          if (showSearch)
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.search, color: Colors.black),
            ),
          
          // Menu icon on rightmost corner
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Top navigation icons bar
  static Widget buildTopNavigation({
    required List<IconData> tabs,
    required int selectedTab,
    required ValueChanged<int> onTabSelected,
  }) {
    return Container(
      color: Colors.white,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selectedTab == index 
                          ? const Color(0xFF1877F2) 
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Icon(
                  tabs[index],
                  color: selectedTab == index 
                      ? const Color(0xFF1877F2) 
                      : Colors.grey[600],
                  size: 28,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Facebook style list tile for friends
  static Widget buildFriendListItem({
    required String name,
    required String imageUrl,
    String? mutualFriends,
    bool isOnline = false,
    VoidCallback? onAddFriend,
    VoidCallback? onRemove,
  }) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Profile picture with online indicator
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF31A24C),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          // Friend info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (mutualFriends != null)
                  Text(
                    mutualFriends,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          
          // Action buttons
          if (onAddFriend != null)
            Container(
              width: 100,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1877F2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextButton(
                onPressed: onAddFriend,
                child: const Text(
                  'Add Friend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.grey),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }

  // Facebook style notification item
  static Widget buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required String imageUrl,
    bool isUnread = false,
    VoidCallback? onTap,
  }) {
    return Container(
      color: isUnread ? const Color(0xFFE7F3FF) : Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Notification icon/image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Notification content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $subtitle',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Options button
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Facebook style section header
  static Widget buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF1877F2),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}