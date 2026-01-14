// models/api_models.dart
class NewsApiResponse {
  final String status;
  final int totalResults;
  final List<NewsApiArticle> articles;

  NewsApiResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    return NewsApiResponse(
      status: json['status'] ?? 'error',
      totalResults: json['totalResults'] ?? 0,
      articles: List<NewsApiArticle>.from(
        (json['articles'] ?? []).map((x) => NewsApiArticle.fromJson(x)),
      ),
    );
  }
}

class NewsApiArticle {
  final ApiSource source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;

  NewsApiArticle({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory NewsApiArticle.fromJson(Map<String, dynamic> json) {
    return NewsApiArticle(
      source: ApiSource.fromJson(json['source'] ?? {}),
      author: json['author'],
      title: json['title'] ?? 'No title',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}

class ApiSource {
  final String? id;
  final String name;

  ApiSource({this.id, required this.name});

  factory ApiSource.fromJson(Map<String, dynamic> json) {
    return ApiSource(
      id: json['id'],
      name: json['name'] ?? 'Unknown Source',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
