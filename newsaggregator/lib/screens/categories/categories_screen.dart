import 'package:flutter/material.dart';
import 'package:local_news/data/dummy_news.dart';
import 'package:local_news/models/news_model.dart';
import 'package:local_news/widgets/custom_bottom_nav.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategory = 'All';
  int _currentIndex = 1;

  final Map<String, IconData> categoryIcons = {
    'All': Icons.dashboard,
    'Politics': Icons.account_balance,
    'Business': Icons.business,
    'Sports': Icons.sports,
    'Culture': Icons.music_note,
    'Technology': Icons.computer,
    'Health': Icons.local_hospital,
    'Weather': Icons.cloud,
    'Local': Icons.location_on,
    'Global': Icons.public,
    'Entertainment': Icons.movie,
    'Education': Icons.school,
  };

  final Map<String, Color> categoryColors = {
    'All': const Color(0xFF1E3A8A),
    'Politics': const Color(0xFFF97316),
    'Business': const Color(0xFF1E3A8A),
    'Sports': const Color(0xFF10B981),
    'Culture': const Color(0xFF8B5CF6),
    'Technology': const Color(0xFF6366F1),
    'Health': const Color(0xFFEF4444),
    'Weather': const Color(0xFF06B6D4),
    'Local': const Color(0xFFF59E0B),
    'Global': const Color(0xFF8B5CF6),
    'Entertainment': const Color(0xFFEC4899),
    'Education': const Color(0xFF0EA5E9),
  };

  List<NewsArticle> getNewsByCategory(String category) {
    if (category == 'All') return dummyNews;
    if (category == 'Local') {
      return dummyNews
          .where((news) =>
              news.category == 'Politics' ||
              news.category == 'Business' ||
              news.category == 'Culture')
          .toList();
    }
    if (category == 'Global') {
      return dummyNews
          .where((news) =>
              news.category == 'Technology' || news.category == 'Sports')
          .toList();
    }
    return dummyNews.where((news) => news.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categoryNews = getNewsByCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Chips with horizontal scrolling
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryIcons.keys.length,
              itemBuilder: (context, index) {
                final category = categoryIcons.keys.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedCategory == category
                          ? categoryColors[category]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedCategory == category
                            ? categoryColors[category]!
                            : Colors.grey[300]!,
                      ),
                      boxShadow: _selectedCategory == category
                          ? [
                              BoxShadow(
                                color:
                                    categoryColors[category]!.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          categoryIcons[category],
                          size: 16,
                          color: _selectedCategory == category
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: TextStyle(
                            color: _selectedCategory == category
                                ? Colors.white
                                : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // News List
          Expanded(
            child: categoryNews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[_selectedCategory],
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No news in $_selectedCategory',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categoryNews.length,
                    itemBuilder: (context, index) {
                      final news = categoryNews[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              news.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            news.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: categoryColors[news.category]
                                          ?.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      news.category.toUpperCase(),
                                      style: TextStyle(
                                        color: categoryColors[news.category],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                              const SizedBox(height: 4),
                              Text(
                                news.source,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                          onTap: () {
                            // Navigate to article detail
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabChange: (index) {
          // Navigation handled by parent
        },
      ),
    );
  }
}
