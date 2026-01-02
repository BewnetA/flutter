// friends_page.dart
import 'package:flutter/material.dart';
import 'facebook_common.dart';
import 'dummy_data.dart';
import 'notifications_page.dart';
import 'home_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int _selectedTopTab = 1; // Friends tab is selected
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
                // In friends_page.dart, update the onTabSelected method in the _buildTopNavigation section:

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
    } else if (index == 2) { // Messages tab
      // Navigator.push for messages page
      // You'll need to create a MessagesPage class
    } else if (index == 3) { // Videos tab
      // Navigator.push for videos page
      // You'll need to create a VideosPage class
    } else if (index == 4) { // Notifications tab
      // Only push if not already on NotificationsPage
      if (!(ModalRoute.of(context)?.settings.name?.contains('NotificationsPage') ?? false)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsPage()),
        );
      }
    } else if (index == 5) { // Marketplace tab
      // Navigator.push for marketplace page
      // You'll need to create a MarketplacePage class
    }
  });
},
              ),
            ),
            
            // Friends Page Header
            SliverToBoxAdapter(
              child: FacebookCommon.buildSectionHeader(
                'Friend Requests',
                onSeeAll: () {
                  // Handle see all friend requests
                },
              ),
            ),
            
            // Friend Requests
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final friend = DummyData.friends[index];
                  return FacebookCommon.buildFriendListItem(
                    name: friend['name'],
                    imageUrl: friend['image'],
                    mutualFriends: friend['mutualFriends'],
                    isOnline: friend['isOnline'],
                    onAddFriend: () {
                      // Handle add friend
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Friend request sent to ${friend['name']}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    onRemove: () {
                      // Handle remove friend request
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Remove Friend Request'),
                          content: Text('Remove friend request from ${friend['name']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed friend request from ${friend['name']}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                childCount: DummyData.friends.length > 3 ? 3 : DummyData.friends.length,
              ),
            ),
            
            // Suggestions Header
            SliverToBoxAdapter(
              child: FacebookCommon.buildSectionHeader(
                'People You May Know',
                onSeeAll: () {
                  // Handle see all suggestions
                },
              ),
            ),
            
            // Friend Suggestions
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final friend = DummyData.friends[index + 3]; // Start from index 3
                  return FacebookCommon.buildFriendListItem(
                    name: friend['name'],
                    imageUrl: friend['image'],
                    mutualFriends: friend['mutualFriends'],
                    isOnline: friend['isOnline'],
                    onAddFriend: () {
                      // Handle add friend
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Friend request sent to ${friend['name']}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    onRemove: () {
                      // Handle remove suggestion
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Remove Suggestion'),
                          content: Text('Remove ${friend['name']} from suggestions?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed ${friend['name']} from suggestions'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                childCount: DummyData.friends.length > 6 ? 3 : DummyData.friends.length - 3,
              ),
            ),
            
            // Birthdays Header
            SliverToBoxAdapter(
              child: FacebookCommon.buildSectionHeader('Birthdays'),
            ),
            
            // Birthdays List
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF0F2F5),
                      ),
                      child: const Icon(
                        Icons.cake,
                        color: Color(0xFF1877F2),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming birthdays',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'See upcoming birthdays and send wishes',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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