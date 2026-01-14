// utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'News Aggregator';
  static const String newsApiKey = '144c7239217643fda2d7033970c75634';
  static const String defaultCountry = 'us';
  static const int defaultPageSize = 20;

  // Default image URL for articles without images
  static const String defaultNewsImage =
      'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=800&auto=format&fit=crop';

  // API Base URL
  static const String newsApiBaseUrl = 'https://newsapi.org/v2';
}

class CategoryColors {
  static const Map<String, int> colorMap = {
    'Politics': 0xFFF97316,
    'Business': 0xFF1E3A8A,
    'Sports': 0xFF10B981,
    'Culture': 0xFF8B5CF6,
    'Technology': 0xFF6366F1,
    'Health': 0xFFEF4444,
    'Entertainment': 0xFFEC4899,
    'Education': 0xFF0EA5E9,
    'Science': 0xFF06B6D4,
    'General': 0xFF6B7280,
  };

  static Color getColor(String category) {
    return Color(colorMap[category] ?? 0xFF6B7280);
  }
}
