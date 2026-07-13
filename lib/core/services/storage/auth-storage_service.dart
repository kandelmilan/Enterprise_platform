import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/app_constants.dart';

class AuthStorageService {
  AuthStorageService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  //==========================================================
  // Access Token
  //==========================================================

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: AppConstants.accessTokenKey);
  }

  //==========================================================
  // Refresh Token
  //==========================================================

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: AppConstants.refreshTokenKey);
  }

  //==========================================================
  // User Id
  //==========================================================

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: AppConstants.userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return _storage.read(key: AppConstants.userIdKey);
  }

  //==========================================================
  // Tenant Id
  //==========================================================

  Future<void> saveTenantId(String tenantId) async {
    await _storage.write(key: AppConstants.tenantIdKey, value: tenantId);
  }

  Future<String?> getTenantId() async {
    return _storage.read(key: AppConstants.tenantIdKey);
  }

  //==========================================================
  // Session Id
  //==========================================================

  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: AppConstants.sessionIdKey, value: sessionId);
  }

  Future<String?> getSessionId() async {
    return _storage.read(key: AppConstants.sessionIdKey);
  }

  //==========================================================
  // Role Id
  //==========================================================

  Future<void> saveRoleId(String roleId) async {
    await _storage.write(key: AppConstants.roleIdKey, value: roleId);
  }

  Future<String?> getRoleId() async {
    return _storage.read(key: AppConstants.roleIdKey);
  }

  //==========================================================
  // Save Complete Login Session
  //==========================================================

  Future<void> saveLoginSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String tenantId,
    required String sessionId,
    required String roleId,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUserId(userId),
      saveTenantId(tenantId),
      saveSessionId(sessionId),
      saveRoleId(roleId),
    ]);
  }

  //==========================================================
  // Login Status
  //==========================================================

  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final sessionId = await getSessionId();

    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty &&
        sessionId != null &&
        sessionId.isNotEmpty;
  }

  //==========================================================
  // Logout
  //==========================================================

  Future<void> clearAuthData() async {
    await Future.wait([
      _storage.delete(key: AppConstants.accessTokenKey),
      _storage.delete(key: AppConstants.refreshTokenKey),
      _storage.delete(key: AppConstants.userIdKey),
      _storage.delete(key: AppConstants.tenantIdKey),
      _storage.delete(key: AppConstants.sessionIdKey),
      _storage.delete(key: AppConstants.roleIdKey),
      _storage.delete(key: AppConstants.lastActivityKey),
    ]);
  }

  //==========================================================
  // Clear Everything
  //==========================================================

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> setFirstLaunchCompleted() async {
    await _storage.write(key: AppConstants.firstLaunchKey, value: "false");
  }

  Future<bool> isFirstLaunch() async {
    final value = await _storage.read(key: AppConstants.firstLaunchKey);

    return value != "false";
  }

  Future<void> clearSession() async {
    await clearAuthData();
  }

  //==========================================================
  // Last Activity
  //==========================================================

  Future<void> saveLastActivity(DateTime dateTime) async {
    await _storage.write(
      key: AppConstants.lastActivityKey,
      value: dateTime.toIso8601String(),
    );
  }

  Future<DateTime?> getLastActivity() async {
    final value = await _storage.read(key: AppConstants.lastActivityKey);

    if (value == null) return null;

    return DateTime.tryParse(value);
  }

  Future<void> clearLastActivity() async {
    await _storage.delete(key: AppConstants.lastActivityKey);
  }

  Future<bool> hasValidSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final userId = await getUserId();
    final tenantId = await getTenantId();
    final sessionId = await getSessionId();
    final roleId = await getRoleId();

    return [
      accessToken,
      refreshToken,
      userId,
      tenantId,
      sessionId,
      roleId,
    ].every((value) => value != null && value.isNotEmpty);
  }
}
