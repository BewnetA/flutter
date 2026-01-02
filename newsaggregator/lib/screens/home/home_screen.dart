import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_news/models/news_model.dart';
import 'package:local_news/screens/home/news_card.dart';

class HomeScreen extends StatefulWidget {
  final List<NewsArticle> newsList;
  final List<String> bookmarkedIds;
  final Function(String) onBookmarkToggle;
  final Function(String) onMarkAsRead;
  final Function(String) onDownload;

  const HomeScreen({
    super.key,
    required this.newsList,
    required this.bookmarkedIds,
    required this.onBookmarkToggle,
    required this.onMarkAsRead,
    required this.onDownload,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _userLocation = 'Addis Ababa';
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Politics',
    'Business',
    'Sports',
    'Culture',
    'Technology',
    'Health',
    'Entertainment',
    'Education',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userLocation = prefs.getString('user_location') ?? 'Addis Ababa';
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No new notifications'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markNotInterested(String newsId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Article hidden from feed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<NewsArticle> get _filteredNews {
    List<NewsArticle> filtered = widget.newsList;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((news) {
        return news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            news.summary.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            news.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((news) => news.category == _selectedCategory).toList();
    }

    // Sort: breaking news first, then by recency
    filtered.sort((a, b) {
      if (a.isBreaking && !b.isBreaking) return -1;
      if (!a.isBreaking && b.isBreaking) return 1;
      return b.publishedAt.compareTo(a.publishedAt);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _filteredNews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No results found for "$_searchQuery"'
                        : 'No news in $_selectedCategory',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredNews.length,
              itemBuilder: (context, index) {
                final news = _filteredNews[index];
                final isBookmarked = widget.bookmarkedIds.contains(news.id);

                return NewsCard(
                  news: news.copyWith(isBookmarked: isBookmarked),
                  onBookmark: () => widget.onBookmarkToggle(news.id),
                  onNotInterested: () => _markNotInterested(news.id),
                  onDownload: () => widget.onDownload(news.id),
                );
              },
            ),
    );
  }

  AppBar _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search for news...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                    selectedColor: const Color(0xFF1E3A8A),
                    labelStyle: TextStyle(
                      color: _selectedCategory == category
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LocalNews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          Text(
            _userLocation,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
          color: Colors.grey[700],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: _showNotifications,
          color: Colors.grey[700],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : 'All';
                    });
                  },
                  selectedColor: const Color(0xFF1E3A8A),
                  labelStyle: TextStyle(
                    color: _selectedCategory == category
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
