// models/news_model.dart (UPDATED)
import 'package:intl/intl.dart';

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
  final int readTime;
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

  // Factory constructor to convert from API model
  factory NewsArticle.fromApi(Map<String, dynamic> apiArticle) {
    // Generate unique ID from URL and timestamp
    final String url = apiArticle['url'] ?? '';
    final String timestamp =
        apiArticle['publishedAt'] ?? DateTime.now().toIso8601String();
    final String id = '${url.hashCode}_${timestamp.hashCode}';

    // Parse date
    DateTime publishedDate;
    try {
      publishedDate = DateTime.parse(apiArticle['publishedAt']);
    } catch (e) {
      publishedDate = DateTime.now();
    }

    // Sanitize text fields
    String sanitize(String? text) {
      if (text == null) return '';
      // Remove [Removed] tags that NewsAPI sometimes adds
      return text.replaceAll(RegExp(r'\[.*?\]'), '').trim();
    }

    final String title = sanitize(apiArticle['title']) != ''
        ? sanitize(apiArticle['title'])
        : 'No title available';

    final String description = sanitize(apiArticle['description']) != ''
        ? sanitize(apiArticle['description'])
        : 'No summary available';

    // Determine category
    final String category = _determineCategory(
      apiArticle['source']['name'] ?? '',
      title.toLowerCase(),
      description.toLowerCase(),
    );

    // Calculate read time
    final String contentText = sanitize(apiArticle['content']) != ''
        ? sanitize(apiArticle['content'])
        : description;
    final int wordCount = contentText.split(' ').length;
    final int estimatedReadTime = (wordCount / 200).ceil();
    final int readTime = estimatedReadTime < 1 ? 1 : estimatedReadTime;

    // Check if breaking news (published within last 2 hours)
    final bool isBreaking =
        DateTime.now().difference(publishedDate).inHours <= 2;

    // Default image if none provided
    final String imageUrl = apiArticle['urlToImage']?.toString().trim() ??
        'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=800&auto=format&fit=crop';

    return NewsArticle(
      id: id,
      title: title,
      summary: description,
      category: category,
      source:
          apiArticle['source']['name']?.toString().trim() ?? 'Unknown Source',
      publishedAt: publishedDate,
      imageUrl: imageUrl,
      content: contentText,
      author: apiArticle['author']?.toString().trim() ?? 'Unknown Author',
      readTime: readTime,
      isBreaking: isBreaking,
      isBookmarked: false,
      isDownloaded: false,
    );
  }

  // Helper to determine category
  static String _determineCategory(
      String source, String title, String description) {
    const categoryMap = {
      'politics': [
        'politics',
        'government',
        'election',
        'senate',
        'congress',
        'white house',
        'trump',
        'biden'
      ],
      'business': [
        'business',
        'economy',
        'market',
        'stock',
        'finance',
        'money',
        'bank',
        'investment'
      ],
      'sports': [
        'sports',
        'game',
        'match',
        'tournament',
        'athlete',
        'nba',
        'nfl',
        'soccer',
        'football'
      ],
      'technology': [
        'tech',
        'technology',
        'ai',
        'software',
        'digital',
        'computer',
        'internet',
        'app',
        'phone'
      ],
      'health': [
        'health',
        'medical',
        'covid',
        'vaccine',
        'hospital',
        'doctor',
        'disease',
        'medicine'
      ],
      'entertainment': [
        'entertainment',
        'movie',
        'celebrity',
        'music',
        'show',
        'hollywood',
        'actor',
        'film'
      ],
      'science': [
        'science',
        'research',
        'study',
        'discovery',
        'space',
        'nasa',
        'climate',
        'environment'
      ],
    };

    final allText = '$title $description $source'.toLowerCase();

    for (final entry in categoryMap.entries) {
      for (final keyword in entry.value) {
        if (allText.contains(keyword)) {
          return entry.key[0].toUpperCase() + entry.key.substring(1);
        }
      }
    }

    // Check source names for common categories
    if (source.toLowerCase().contains('tech')) return 'Technology';
    if (source.toLowerCase().contains('sport')) return 'Sports';
    if (source.toLowerCase().contains('business')) return 'Business';
    if (source.toLowerCase().contains('health')) return 'Health';

    return 'General';
  }

  // Keep your existing methods
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
      return DateFormat('dd/MM/yyyy').format(publishedAt);
    }
  }

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
