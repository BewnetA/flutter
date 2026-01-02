// notifications_page.dart
import 'package:flutter/material.dart';
import 'facebook_common.dart';
import 'dummy_data.dart';
import 'friends_page.dart';
import 'home_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedTopTab = 4; // Notifications tab is selected
  final ScrollController _scrollController = ScrollController();
  
  final List<IconData> _topTabs = [
    Icons.home,
    Icons.people,
    Icons.message,
    Icons.ondemand_video,
    Icons.notifications,
    Icons.store,
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Facebook Header
            SliverToBoxAdapter(
              child: FacebookCommon.buildFacebookHeader(),
            ),
            
            // Top Navigation Icons
            SliverToBoxAdapter(
              child: FacebookCommon.buildTopNavigation(
                tabs: _topTabs,
                selectedTab: _selectedTopTab,
                // In notifications_page.dart, update the onTabSelected method in the _buildTopNavigation section:

onTabSelected: (index) {
  setState(() {
    _selectedTopTab = index;
    // Navigate to other pages based on tab index
    if (index == 0) { // Home tab
      // Use pushReplacement to replace current page with HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) { // Friends tab
      // Only push if not already on FriendsPage
      if (!(ModalRoute.of(context)?.settings.name?.contains('FriendsPage') ?? false)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FriendsPage()),
        );
      }
    } else if (index == 2) { // Messages tab
      // Navigator.push for messages page
      // You'll need to create a MessagesPage class
    } else if (index == 3) { // Videos tab
      // Navigator.push for videos page
      // You'll need to create a VideosPage class
    } else if (index == 5) { // Marketplace tab
      // Navigator.push for marketplace page
      // You'll need to create a MarketplacePage class
    }
  });
},
              ),
            ),
            
            // Notifications Page Header
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Unread Notifications Header
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Row(
                  children: [
                    Text(
                      'New',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Mark all as read',
                      style: TextStyle(
                        color: Color(0xFF1877F2),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Unread Notifications
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = DummyData.notifications[index];
                  if (notification['isUnread'] == true) {
                    return FacebookCommon.buildNotificationItem(
                      title: notification['title'],
                      subtitle: notification['subtitle'],
                      time: notification['time'],
                      imageUrl: notification['image'],
                      isUnread: true,
                      onTap: () {
                        // Handle notification tap
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${notification['title']}\'s notification'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
                childCount: DummyData.notifications.length,
              ),
            ),
            
            // Earlier Notifications Header
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.only(top: 8),
                child: const Text(
                  'Earlier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Earlier Notifications
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = DummyData.notifications[index];
                  if (notification['isUnread'] == false) {
                    return FacebookCommon.buildNotificationItem(
                      title: notification['title'],
                      subtitle: notification['subtitle'],
                      time: notification['time'],
                      imageUrl: notification['image'],
                      isUnread: false,
                      onTap: () {
                        // Handle notification tap
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${notification['title']}\'s notification'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
                childCount: DummyData.notifications.length,
              ),
            ),
            
            // Spacer at bottom
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}