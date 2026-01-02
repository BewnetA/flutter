class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String category;
  final String source;
  final DateTime publishedAt;
  final String imageUrl;
  final String content;
  final String author;
  final int readTime; // in minutes
  final bool isBreaking;
  final bool isBookmarked;
  final bool isDownloaded;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.content,
    required this.author,
    this.readTime = 3,
    this.isBreaking = false,
    this.isBookmarked = false,
    this.isDownloaded = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
    }
  }

  // Add copyWith method
  NewsArticle copyWith({
    String? id,
    String? title,
    String? summary,
    String? category,
    String? source,
    DateTime? publishedAt,
    String? imageUrl,
    String? content,
    String? author,
    int? readTime,
    bool? isBreaking,
    bool? isBookmarked,
    bool? isDownloaded,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      author: author ?? this.author,
      readTime: readTime ?? this.readTime,
      isBreaking: isBreaking ?? this.isBreaking,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
