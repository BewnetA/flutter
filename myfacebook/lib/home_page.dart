import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';
import 'dummy_data.dart';
import 'facebook_common.dart';
import 'friends_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  final String? userEmail;
  final String? userName;

  const HomePage({super.key, this.userEmail, this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  int _selectedTopTab = 0;
  final ScrollController _scrollController = ScrollController();

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    // Sign out from Google and Firebase
    await _authService.signOut();

    setState(() {
      _isLoading = false;
    });

    // Navigate back to login page
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

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
              child: _buildTopNavigation(),
            ),
            
            // Create Post Section
            SliverToBoxAdapter(
              child: _buildCreatePostSection(),
            ),
            
            // Divider
            SliverToBoxAdapter(
              child: Container(height: 10, color: const Color(0xFFF0F2F5)),
            ),
            
            // Stories Section
            SliverToBoxAdapter(
              child: _buildStoriesSection(),
            ),
            
            // Divider
            SliverToBoxAdapter(
              child: Container(height: 10, color: const Color(0xFFF0F2F5)),
            ),
            
            // Post Feed Section
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = DummyData.posts[index];
                  if (post['postImage'] != null) {
                    return _buildImagePost(
                      userName: post['userName'],
                      userImage: post['userImage'],
                      time: post['time'],
                      content: post['content'],
                      postImage: post['postImage'],
                      likes: post['likes'],
                      comments: post['comments'],
                      shares: post['shares'],
                    );
                  } else {
                    return _buildTextPost(
                      userName: post['userName'],
                      userImage: post['userImage'],
                      time: post['time'],
                      content: post['content'],
                      likes: post['likes'],
                      comments: post['comments'],
                      shares: post['shares'],
                    );
                  }
                },
                childCount: DummyData.posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Facebook header with Facebook text on left and menu icon on right
  Widget _buildFacebookHeader() {
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
          
          // Search icon
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

  // Top navigation icons (Home, Friends, Messages, Videos, Notifications, Marketplace)
  Widget _buildTopNavigation() {
    return FacebookCommon.buildTopNavigation(
      tabs: _topTabs,
      selectedTab: _selectedTopTab,
      // In HomePage.dart, update the onTabSelected method in the _buildTopNavigation section:

onTabSelected: (index) {
  setState(() {
    _selectedTopTab = index;
    // Navigate to other pages based on tab index
    if (index == 1) { // Friends tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FriendsPage()),
      );
    } else if (index == 4) { // Notifications tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsPage()),
      );
    }
    // Home tab (index 0) does nothing since we're already on HomePage
    // Note: For other tabs (Messages, Videos, Marketplace)
    // you'll need to implement their respective pages
  });
},
    );
  }

  // Create Post Section
  Widget _buildCreatePostSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Left: Profile image with online indicator
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(DummyData.currentUser['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF31A24C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          
          // Center: Text input placeholder
          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What's on your mind?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          
          // Right: Gallery/photo icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Icon(Icons.photo_library_outlined, color: Color(0xFF45BD62)),
          ),
        ],
      ),
      );
  }

  // Stories Section
  Widget _buildStoriesSection() {
    return Container(
      color: Colors.white,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stories label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'Stories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Horizontal scrollable stories
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: DummyData.stories.map((story) {
                if (story['type'] == 'create') {
                  // Create Story Card
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Stack(
                      children: [
                        // User profile background
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            story['storyImage'],
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        // Plus icon on blue circle
                        Positioned(
                          top: 100,
                          left: 35,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1877F2),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        
                        // "Create story" text
                        Container(
                          margin: const EdgeInsets.only(top: 140),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            story['userName'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Friend story
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(story['storyImage']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        
                        // Friend profile circle with blue border
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1877F2), width: 3),
                              image: DecorationImage(
                                image: NetworkImage(story['userImage']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        
                        // Friend name
                        Positioned(
                          bottom: 12,
                          left: 8,
                          right: 8,
                          child: Text(
                            story['userName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Build a post with image
  Widget _buildImagePost({
    required String userName,
    required String userImage,
    required String time,
    required String content,
    required String postImage,
    required String likes,
    required String comments,
    required String shares,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // User profile
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // User name and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '$time • ',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          Icon(Icons.public, size: 12, color: Colors.grey[600]),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // More options
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Post image
          Image.network(
            postImage,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          
          // Post stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Reaction icons
                Stack(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: const Center(
                          child: Icon(Icons.favorite, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Text(
                  likes,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '$comments comments • $shares shares',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(height: 1, color: Colors.grey[300]),
          
          // Post actions (icons only)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up_outlined, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment_outlined, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share_outlined, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build a text-only post
  Widget _buildTextPost({
    required String userName,
    required String userImage,
    required String time,
    required String content,
    required String likes,
    required String comments,
    required String shares,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '$time • ',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          Icon(Icons.public, size: 12, color: Colors.grey[600]),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Post stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: const Center(
                          child: Icon(Icons.favorite, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Text(
                  likes,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '$comments comments • $shares shares',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(height: 1, color: Colors.grey[300]),
          
          // Post actions (icons only)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up_outlined, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment_outlined, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share_outlined, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}