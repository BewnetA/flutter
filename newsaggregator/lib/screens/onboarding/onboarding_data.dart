import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final String icon;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });
}

List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    title: 'Local News',
    description: 'Stay updated with news from your city and neighborhood',
    icon: '📰',
    backgroundColor: Color(0xFF1E3A8A),
  ),
  OnboardingPage(
    title: 'Personalized Feed',
    description: 'Get news tailored to your interests and location',
    icon: '🎯',
    backgroundColor: Color(0xFFF97316),
  ),
  OnboardingPage(
    title: 'Offline Reading',
    description: 'Save articles to read later without internet',
    icon: '📱',
    backgroundColor: Color(0xFF10B981),
  ),
  OnboardingPage(
    title: 'Bookmark & Save',
    description: 'Save important news for quick access anytime',
    icon: '⭐',
    backgroundColor: Color(0xFF8B5CF6),
  ),
];
