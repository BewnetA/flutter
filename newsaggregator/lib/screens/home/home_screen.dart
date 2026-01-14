// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_news/models/news_model.dart';
import 'package:local_news/screens/home/news_card.dart';
import 'package:local_news/services/news_service.dart';

class HomeScreen extends StatefulWidget {
  final List<String> bookmarkedIds;
  final Function(String) onBookmarkToggle;
  final Function(String) onMarkAsRead;
  final Function(String) onDownload;

  const HomeScreen({
    super.key,
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
  late Future<List<NewsArticle>> _newsFuture;
  final NewsService _newsService = NewsService();
  bool _isLoading = false;

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
    _loadNews();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userLocation = prefs.getString('user_location') ?? 'Addis Ababa';
    });
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_searchQuery.isNotEmpty) {
        _newsFuture = _newsService.searchNews(query: _searchQuery);
      } else if (_selectedCategory != 'All') {
        _newsFuture = _newsService.getNewsByCategory(_selectedCategory);
      } else {
        _newsFuture = _newsService.getTopHeadlines();
      }

      await _newsFuture;
    } catch (e) {
      print('Error loading news: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshNews() async {
  _newsService.clearCache();
  await _loadNews();
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
      _loadNews(); // Reload with original news
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (query.isNotEmpty) {
      _loadNews(); // Trigger search API call
    } else {
      _refreshNews(); // Clear search and show original news
    }
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

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _searchQuery.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FutureBuilder<List<NewsArticle>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final newsList = snapshot.data!;
        return _buildNewsList(newsList);
      },
    );
  }

  Widget _buildNewsList(List<NewsArticle> newsList) {
    // Filter and sort the news list
    List<NewsArticle> filteredNews = newsList;

    // Apply local search filter if search query exists
    if (_searchQuery.isNotEmpty) {
      filteredNews = filteredNews.where((news) {
        return news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            news.summary.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            news.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            news.source.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply local category filter if needed
    if (_selectedCategory != 'All') {
      filteredNews = filteredNews
          .where((news) => news.category == _selectedCategory)
          .toList();
    }

    // Sort: breaking news first, then by recency
    filteredNews.sort((a, b) {
      if (a.isBreaking && !b.isBreaking) return -1;
      if (!a.isBreaking && b.isBreaking) return 1;
      return b.publishedAt.compareTo(a.publishedAt);
    });

    if (filteredNews.isEmpty) {
      return _buildEmptySearchState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _refreshNews();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredNews.length,
        itemBuilder: (context, index) {
          final news = filteredNews[index];
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

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load news',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error.contains('rate limit')
                  ? 'Daily API limit reached. Try again tomorrow.'
                  : 'Please check your internet connection.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadNews,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
                : 'No news available',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedCategory != 'All'
                ? 'Try changing the category or pull to refresh'
                : 'Pull down to refresh or try again later',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshNews,
            child: const Text('Refresh News'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No results found for "$_searchQuery"',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching with different keywords',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _stopSearch();
            },
            child: const Text('Clear Search'),
          ),
        ],
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
                      if (selected) {
                        _onCategorySelected(category);
                      }
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
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
          onPressed: _isLoading ? null : _refreshNews,
          color: Colors.grey[700],
          tooltip: 'Refresh news',
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
                    if (selected) {
                      _onCategorySelected(category);
                    }
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
