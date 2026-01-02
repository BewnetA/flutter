import 'package:flutter/material.dart';
import 'package:local_news/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle news;
  final VoidCallback onBookmark;
  final VoidCallback onNotInterested;
  final VoidCallback onDownload;

  const NewsCard({
    super.key,
    required this.news,
    required this.onBookmark,
    required this.onNotInterested,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    Color getCategoryColor(String category) {
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
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News image with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  news.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              if (news.isBreaking)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
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
                ),
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    if (news.isDownloaded)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.download_done,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: news.isBookmarked ? Colors.amber : Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // News content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getCategoryColor(news.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        news.category.toUpperCase(),
                        style: TextStyle(
                          color: getCategoryColor(news.category),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${news.readTime} min read',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Summary
                Text(
                  news.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Footer with source and action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.source,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            news.timeAgo,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // Share button
                        IconButton(
                          icon: const Icon(Icons.share),
                          iconSize: 20,
                          color: Colors.grey[600],
                          onPressed: () {
                            // Share functionality
                          },
                        ),
                        // More options menu
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (value) {
                            if (value == 'bookmark') {
                              onBookmark();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    news.isBookmarked
                                        ? 'Article removed from bookmarks'
                                        : 'Article bookmarked',
                                  ),
                                ),
                              );
                            } else if (value == 'not_interested') {
                              onNotInterested();
                            } else if (value == 'download') {
                              onDownload();
                            } else if (value == 'share') {
                              // Share functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Sharing article...')),
                              );
                            } else if (value == 'report') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Report Article'),
                                  content: const Text(
                                      'Why are you reporting this article?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Article reported. Thank you for your feedback.')),
                                        );
                                      },
                                      child: const Text('Report'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'bookmark',
                              child: Row(
                                children: [
                                  Icon(
                                    news.isBookmarked
                                        ? Icons.bookmark_remove
                                        : Icons.bookmark_add,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 12),
                                  Text(news.isBookmarked
                                      ? 'Remove bookmark'
                                      : 'Bookmark article'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'not_interested',
                              child: Row(
                                children: [
                                  const Icon(Icons.visibility_off,
                                      color: Colors.grey),
                                  const SizedBox(width: 12),
                                  const Text('Not interested'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'download',
                              child: Row(
                                children: [
                                  const Icon(Icons.download,
                                      color: Colors.grey),
                                  const SizedBox(width: 12),
                                  const Text('Download for offline'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'share',
                              child: Row(
                                children: [
                                  const Icon(Icons.share, color: Colors.grey),
                                  const SizedBox(width: 12),
                                  const Text('Share article'),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'report',
                              child: Row(
                                children: [
                                  const Icon(Icons.report, color: Colors.red),
                                  const SizedBox(width: 12),
                                  const Text('Report article',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
