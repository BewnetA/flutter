// utils/helpers.dart
import 'package:intl/intl.dart';

class Helpers {
  // Format date to time ago string
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  // Sanitize text from NewsAPI (removes [Removed] tags)
  static String sanitizeText(String? text) {
    if (text == null) return '';
    
    // Remove [Removed], [+ chars] tags
    final regex = RegExp(r'\[.*?\]');
    String sanitized = text.replaceAll(regex, '').trim();
    
    return sanitized.isNotEmpty ? sanitized : 'Content not available';
  }

  // Calculate estimated read time
  static int calculateReadTime(String? content) {
    if (content == null || content.isEmpty) return 3;
    
    final wordCount = content.split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  // Check if news is breaking (published within last 2 hours)
  static bool isBreakingNews(DateTime publishedAt) {
    return DateTime.now().difference(publishedAt).inHours <= 2;
  }

  // Generate unique ID for article
  static String generateArticleId(String url, String publishedAt) {
    return '${url.hashCode}_${publishedAt.hashCode}';
  }
}