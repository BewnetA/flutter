import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/trending/trending_screen.dart';
import 'screens/bookmarks/bookmarks_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'data/dummy_news.dart';
import 'models/news_model.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  bool _isFirstLaunch = true;
  bool _isLoggedIn = false;
  bool _isLoading = true;
  final List<String> _bookmarkedIds = [];

  final List<NewsArticle> _newsList = dummyNews;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstLaunch = prefs.getBool('first_launch') ?? true;
      _isLoggedIn = prefs.getString('user_email') != null;
      _isLoading = false;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    setState(() {
      _isFirstLaunch = false;
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isLoggedIn = false;
      _currentIndex = 0;
      _bookmarkedIds.clear();
    });
  }

  void _toggleBookmark(String newsId) {
    setState(() {
      if (_bookmarkedIds.contains(newsId)) {
        _bookmarkedIds.remove(newsId);
      } else {
        _bookmarkedIds.add(newsId);
      }
    });
  }

  void _markAsRead(String newsId) {
    // Could implement read tracking here
  }

  void _downloadArticle(String newsId) {
    // Show snackbar using the current context
    final context = _contextKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article downloaded for offline reading'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Key to access context from anywhere
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey _contextKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isFirstLaunch) {
      return OnboardingScreen(
        onCompleted: _completeOnboarding,
      );
    }

    if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: _handleLoginSuccess,
      );
    }

    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: Scaffold(
        key: _contextKey,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(
              newsList: _newsList,
              bookmarkedIds: _bookmarkedIds,
              onBookmarkToggle: _toggleBookmark,
              onMarkAsRead: _markAsRead,
              onDownload: _downloadArticle,
            ),
            TrendingScreen(
              newsList: _newsList,
              bookmarkedIds: _bookmarkedIds,
              onBookmarkToggle: _toggleBookmark,
              onMarkAsRead: _markAsRead,
              onDownload: _downloadArticle,
            ),
            BookmarksScreen(
              newsList: _newsList,
              bookmarkedIds: _bookmarkedIds,
              onBookmarkToggle: _toggleBookmark,
              onMarkAsRead: _markAsRead,
              onDownload: _downloadArticle,
            ),
            SettingsScreen(onLogout: _handleLogout),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 'Home', 0),
              _buildNavItem(Icons.trending_up, 'Trending', 1),
              _buildNavItem(Icons.bookmark, 'Saved', 2),
              _buildNavItem(Icons.settings, 'Settings', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(30, 58, 138, 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
