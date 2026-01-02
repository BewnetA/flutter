import 'package:flutter/foundation.dart';

class WebUtils {
  static bool get isWeb => kIsWeb;

  static String get defaultFontFamily {
    if (kIsWeb) {
      return 'Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Oxygen, Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue, sans-serif';
    }
    return 'Inter';
  }
}
