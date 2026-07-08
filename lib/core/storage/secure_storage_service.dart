// This will manage:
// Access Token
// Refresh Token
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

class SecureStorageService {
  SecureStorageService();

  static final SecureStorageService instance = SecureStorageService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
  }

  /// Get Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }

  /// Save Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  /// Get Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.refreshTokenKey);
  }

  /// Save User (Optional)
  Future<void> saveUser(String userJson) async {
    await _storage.write(key: AppConstants.userKey, value: userJson);
  }

  /// Get User
  Future<String?> getUser() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  /// Check Login Status
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear Authentication Data
  Future<void> clearAuthData() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }

  /// Clear Everything
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
