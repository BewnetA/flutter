import 'package:flutter/material.dart';
import 'package:local_news/models/news_model.dart';
import 'package:local_news/screens/home/news_card.dart';

class BookmarksScreen extends StatelessWidget {
  final List<NewsArticle> newsList;
  final List<String> bookmarkedIds;
  final Function(String) onBookmarkToggle;
  final Function(String) onMarkAsRead;
  final Function(String) onDownload;

  const BookmarksScreen({
    super.key,
    required this.newsList,
    required this.bookmarkedIds,
    required this.onBookmarkToggle,
    required this.onMarkAsRead,
    required this.onDownload,
  });

  List<NewsArticle> get _bookmarkedNews {
    return newsList
        .where((news) => bookmarkedIds.contains(news.id))
        .map((news) => news.copyWith(isBookmarked: true))
        .toList();
  }

  void _clearAllBookmarks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text(
            'Are you sure you want to remove all bookmarked articles?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (final news in _bookmarkedNews) {
                onBookmarkToggle(news.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All bookmarks cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedNews = _bookmarkedNews;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Saved Articles (${bookmarkedNews.length})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        actions: bookmarkedNews.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _clearAllBookmarks(context),
                  tooltip: 'Clear all bookmarks',
                ),
              ]
            : null,
      ),
      body: bookmarkedNews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved articles',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bookmark articles to read them later',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedNews.length,
              itemBuilder: (context, index) {
                final news = bookmarkedNews[index];
                return NewsCard(
                  news: news,
                  onBookmark: () => onBookmarkToggle(news.id),
                  onNotInterested: () {
                    onBookmarkToggle(news.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Article removed from bookmarks'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onDownload: () => onDownload(news.id),
                );
              },
            ),
    );
  }
}
