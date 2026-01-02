import '../models/news_model.dart';

List<NewsArticle> dummyNews = [
  NewsArticle(
    id: '1',
    title: 'New Urban Development Plan Approved for City Center',
    summary:
        'City council approves massive redevelopment project focusing on sustainable infrastructure',
    category: 'Politics',
    source: 'City Gazette',
    publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    imageUrl:
        'https://images.unsplash.com/photo-1572949645841-094f3a9c4c94?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    content:
        'The city council has unanimously approved a new urban development plan that aims to transform the city center into a more sustainable and pedestrian-friendly area. The project includes new green spaces, improved public transportation, and modernized infrastructure.',
    author: 'John Smith',
    readTime: 4,
    isBreaking: true,
    isBookmarked: false,
    isDownloaded: false,
  ),
  NewsArticle(
    id: '2',
    title: 'Local Tech Startups Receive Record Funding',
    summary: 'Three local tech companies secure over 50M in Series B funding',
    category: 'Business',
    source: 'TechDaily',
    publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
    imageUrl:
        'https://www.investopedia.com/thmb/SPOl62NtucSLHi9-XyGJxm-Wo68=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-943067460-28883b8136b24330932cd4e2855c2508.jpg',
    content:
        'Local tech startups have secured record funding this quarter, with three companies raising over 50 million in Series B funding rounds. Investors are showing increased confidence in the local tech ecosystem.',
    author: 'Sarah Johnson',
    readTime: 3,
    isBreaking: false,
    isBookmarked: false,
    isDownloaded: true,
  ),
  NewsArticle(
    id: '3',
    title: 'Annual Jazz Festival Announces Lineup',
    summary:
        'International artists confirmed for this year\'s city jazz festival',
    category: 'Culture',
    source: 'ArtsWeekly',
    publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
    imageUrl:
        'https://images.unsplash.com/photo-1544717305-2782549b5136?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    content:
        'The annual city jazz festival has announced its lineup, featuring international artists from around the world. The month-long event will take place in various venues across the city.',
    author: 'Michael Brown',
    readTime: 2,
    isBreaking: false,
    isBookmarked: true,
    isDownloaded: false,
  ),
  NewsArticle(
    id: '4',
    title: 'City Marathon Expected to Draw Thousands',
    summary: 'Annual marathon route announced with new scenic additions',
    category: 'Sports',
    source: 'SportsNet',
    publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
    imageUrl:
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    content:
        'The annual city marathon is expected to draw over 10,000 participants this year. The route has been updated to include more scenic views and better spectator areas.',
    author: 'David Wilson',
    readTime: 5,
    isBreaking: false,
    isBookmarked: false,
    isDownloaded: false,
  ),
  NewsArticle(
    id: '5',
    title: 'Major Road Construction to Begin Next Month',
    summary: 'Three-month project aims to reduce traffic congestion',
    category: 'Transport',
    source: 'City Gazette',
    publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    imageUrl:
        'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    content:
        'A major road construction project will begin next month, aiming to reduce traffic congestion in the downtown area. The project is expected to last three months.',
    author: 'Lisa Taylor',
    readTime: 3,
    isBreaking: true,
    isBookmarked: false,
    isDownloaded: false,
  ),
  // Add these to the existing list
  NewsArticle(
    id: '6',
    title: 'Local Farmers Market Opens New Location',
    summary: 'Weekly farmers market expands to accommodate more local vendors',
    category: 'Local',
    source: 'City Chronicle',
    publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
    imageUrl:
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    content:
        'The weekly farmers market has opened a new location in the downtown area...',
    author: 'Maria Garcia',
    readTime: 2,
    isBreaking: false,
    isBookmarked: false,
    isDownloaded: false,
  ),
  NewsArticle(
    id: '7',
    title: 'Global Climate Summit Agreement Reached',
    summary:
        'World leaders agree on new climate targets at international summit',
    category: 'Global',
    source: 'World News Network',
    publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
    imageUrl:
        'https://images.unsplash.com/photo-1589652717521-10c0d092dea9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    content:
        'World leaders have reached a historic agreement at the Global Climate Summit...',
    author: 'Global News Team',
    readTime: 5,
    isBreaking: true,
    isBookmarked: false,
    isDownloaded: false,
  ),
];
