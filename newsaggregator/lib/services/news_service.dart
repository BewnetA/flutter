// services/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../models/api_models.dart';

class NewsService {
  static const String _apiKey = '144c7239217643fda2d7033970c75634';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Cache to avoid duplicate requests
  final Map<String, List<NewsArticle>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheDuration = const Duration(minutes: 10);

  // Singleton instance
  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;
  NewsService._internal();

  // Get top headlines
  Future<List<NewsArticle>> getTopHeadlines({
    String country = 'us',
    String? category,
    int pageSize = 20,
  }) async {
    final cacheKey = 'headlines_${country}_${category ?? 'all'}_$pageSize';

    // Check cache
    if (_isCacheValid(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      // Build query parameters
      final params = {
        'apiKey': _apiKey,
        'country': country,
        'pageSize': pageSize.toString(),
      };

      if (category != null && category.isNotEmpty && category != 'all') {
        params['category'] = category.toLowerCase();
      }

      final uri =
          Uri.parse('$_baseUrl/top-headlines').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiResponse = NewsApiResponse.fromJson(data);

        // Convert API articles to your NewsArticle model
        final articles = apiResponse.articles.map((apiArticle) {
          return NewsArticle.fromApi(apiArticle.toJson());
        }).toList();

        // Update cache
        _cache[cacheKey] = articles;
        _cacheTimestamps[cacheKey] = DateTime.now();

        return articles;
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching headlines: $e');

      // Return cached data if available, even if expired
      if (_cache.containsKey(cacheKey)) {
        return _cache[cacheKey]!;
      }

      throw Exception(
          'Failed to load news. Please check your internet connection.');
    }
  }

  // Search news
  Future<List<NewsArticle>> searchNews({
    required String query,
    String language = 'en',
    String sortBy = 'publishedAt',
    int pageSize = 20,
  }) async {
    final cacheKey = 'search_${query}_$language';

    try {
      final uri = Uri.parse('$_baseUrl/everything').replace(queryParameters: {
        'apiKey': _apiKey,
        'q': query,
        'language': language,
        'sortBy': sortBy,
        'pageSize': pageSize.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiResponse = NewsApiResponse.fromJson(data);

        final articles = apiResponse.articles.map((apiArticle) {
          return NewsArticle.fromApi(apiArticle.toJson());
        }).toList();

        // Update cache
        _cache[cacheKey] = articles;
        _cacheTimestamps[cacheKey] = DateTime.now();

        return articles;
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching news: $e');

      // Return cached data if available
      if (_cache.containsKey(cacheKey)) {
        return _cache[cacheKey]!;
      }

      throw Exception('Search failed. Please try again.');
    }
  }

  // Get news by category
  Future<List<NewsArticle>> getNewsByCategory(String category) async {
    return getTopHeadlines(category: category);
  }

  // Check if cache is still valid
  bool _isCacheValid(String key) {
    if (!_cache.containsKey(key) || !_cacheTimestamps.containsKey(key)) {
      return false;
    }

    final lastFetch = _cacheTimestamps[key]!;
    return DateTime.now().difference(lastFetch) < _cacheDuration;
  }

  // Clear cache
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  // Get available categories
  static List<String> getCategories() {
    return [
      'All',
      'Business',
      'Entertainment',
      'General',
      'Health',
      'Science',
      'Sports',
      'Technology',
    ];
  }
}
