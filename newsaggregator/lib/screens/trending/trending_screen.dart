import 'package:flutter/material.dart';
import 'package:local_news/models/news_model.dart';
import 'package:local_news/screens/home/news_card.dart';

class TrendingScreen extends StatefulWidget {
  final List<NewsArticle> newsList;
  final List<String> bookmarkedIds;
  final Function(String) onBookmarkToggle;
  final Function(String) onMarkAsRead;
  final Function(String) onDownload;

  const TrendingScreen({
    super.key,
    required this.newsList,
    required this.bookmarkedIds,
    required this.onBookmarkToggle,
    required this.onMarkAsRead,
    required this.onDownload,
  });

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  String _selectedFilter = 'Today';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _timeFilters = ['Today', 'This Week', 'This Month'];
  final List<String> _trendingHashtags = [
    '#BreakingNews',
    '#Election2024',
    '#TechUpdate',
    '#ClimateChange',
    '#SportsNews',
    '#MarketCrash',
    '#HealthAlert',
    '#Entertainment'
  ];

  List<NewsArticle> get _trendingNews {
    // Sort by isBreaking first, then by recency
    List<NewsArticle> sortedNews = List.from(widget.newsList);
    sortedNews.sort((a, b) {
      if (a.isBreaking && !b.isBreaking) return -1;
      if (!a.isBreaking && b.isBreaking) return 1;
      return b.publishedAt.compareTo(a.publishedAt);
    });

    // Filter by time period
    final now = DateTime.now();
    if (_selectedFilter == 'Today') {
      sortedNews = sortedNews.where((news) {
        return news.publishedAt.isAfter(now.subtract(const Duration(days: 1)));
      }).toList();
    } else if (_selectedFilter == 'This Week') {
      sortedNews = sortedNews.where((news) {
        return news.publishedAt.isAfter(now.subtract(const Duration(days: 7)));
      }).toList();
    }

    return sortedNews.take(15).toList(); // Limit to top 15 trending
  }

  Map<String, List<NewsArticle>> get _newsByCategory {
    final Map<String, List<NewsArticle>> categoryMap = {};

    for (final news in widget.newsList) {
      if (!categoryMap.containsKey(news.category)) {
        categoryMap[news.category] = [];
      }
      categoryMap[news.category]!.add(news);
    }

    // Sort each category by recency
    for (final category in categoryMap.keys) {
      categoryMap[category]!
          .sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    }

    return categoryMap;
  }

  List<String> get _topCategories {
    final categories = _newsByCategory.keys.toList();
    categories.sort((a, b) =>
        _newsByCategory[b]!.length.compareTo(_newsByCategory[a]!.length));
    return categories.take(4).toList();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Filters
            _buildTimeFilters(),

            // Trending Hashtags
            _buildTrendingHashtags(),

            // Top Stories Section
            _buildTopStoriesSection(),

            // Trending by Category
            _buildTrendingByCategory(),
          ],
        ),
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
            hintText: 'Search trending news...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            // Implement search functionality
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _searchController.clear(),
          ),
        ],
      );
    }

    return AppBar(
      title: const Text(
        'Trending',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Color(0xFF111827),
        ),
      ),
      centerTitle: false,
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
    );
  }

  Widget _buildTimeFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: _timeFilters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = selected ? filter : 'Today';
              });
            },
            selectedColor: const Color(0xFF1E3A8A),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrendingHashtags() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Topics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _trendingHashtags.length,
              itemBuilder: (context, index) {
                final hashtag = _trendingHashtags[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(hashtag),
                    backgroundColor: const Color.fromRGBO(59, 130, 246, 0.1),
                    labelStyle: const TextStyle(
                      color: Color(0xFF1E40AF),
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStoriesSection() {
    final topStories = _trendingNews.take(3).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Stories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          ...topStories.asMap().entries.map((entry) {
            final index = entry.key;
            final news = entry.value;
            final isBookmarked = widget.bookmarkedIds.contains(news.id);

            return Container(
              margin: EdgeInsets.only(
                  bottom: index < topStories.length - 1 ? 16 : 0),
              child: _buildTopStoryCard(news, isBookmarked),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopStoryCard(NewsArticle news, bool isBookmarked) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => widget.onMarkAsRead(news.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${_trendingNews.indexOf(news) + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (news.isBreaking)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'BREAKING',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (news.isBreaking) const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            news.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(news.category)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            news.category.toUpperCase(),
                            style: TextStyle(
                              color: _getCategoryColor(news.category),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${news.readTime} min read',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          news.timeAgo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bookmark button
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? const Color(0xFF1E3A8A) : Colors.grey,
                ),
                onPressed: () => widget.onBookmarkToggle(news.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingByCategory() {
    final topCategories = _topCategories;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending by Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          for (final category in topCategories) _buildCategorySection(category),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category) {
    final categoryNews = _newsByCategory[category]!.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to category page
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final news in categoryNews)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: NewsCard(
              news: news.copyWith(
                  isBookmarked: widget.bookmarkedIds.contains(news.id)),
              onBookmark: () => widget.onBookmarkToggle(news.id),
              onNotInterested: () {},
              onDownload: () => widget.onDownload(news.id),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Politics':
        return const Color(0xFFF97316);
      case 'Business':
        return const Color(0xFF1E3A8A);
      case 'Sports':
        return const Color(0xFF10B981);
      case 'Culture':
        return const Color(0xFF8B5CF6);
      case 'Technology':
        return const Color(0xFF6366F1);
      case 'Health':
        return const Color(0xFFEF4444);
      case 'Entertainment':
        return const Color(0xFFEC4899);
      case 'Education':
        return const Color(0xFF0EA5E9);
      default:
        return Colors.grey;
    }
  }
}
