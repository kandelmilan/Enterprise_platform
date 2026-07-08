// Store values that are used across the app.
class AppConstants {
  AppConstants._();

  // =========================
  // App
  // =========================

  static const String appName = 'Enterprise Platform';

  // =========================
  // API
  // =========================

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // =========================
  // Storage Keys
  // =========================

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';

  // =========================
  // Pagination
  // =========================

  static const int defaultPageSize = 10;

  // =========================
  // Animation
  // =========================

  static const Duration animationDuration = Duration(milliseconds: 300);
}
