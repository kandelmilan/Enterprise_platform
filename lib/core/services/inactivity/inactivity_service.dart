import 'dart:async';

import 'package:enterprise_platform/core/core.dart';
import 'package:flutter/foundation.dart';

class InactivityService {
  InactivityService(
    this._storage, {
    this.timeout = const Duration(minutes: 15),
  });

  final AuthStorageService _storage;
  final Duration timeout;

  Timer? _timer;
  bool _tracking = false;

  VoidCallback? onTimeout;

  Future<void> initialize() async {
    _tracking = true;
    await _storage.saveLastActivity(DateTime.now());
    _startTimer();
  }

  Future<void> resetTimer() async {
    if (!_tracking) return;

    await _storage.saveLastActivity(DateTime.now());

    // ==========================================================
    // TODO(HYDRO SYNC):
    // Register the user's activity locally.
    // If internet is available:
    //    → Send activity to the server immediately.
    // Otherwise:
    //    → Save it to the local offline queue/database.
    // The SyncService will automatically upload the pending
    // activities once connectivity is restored.
    // ==========================================================

    _startTimer();
  }

  Future<void> pauseTimer() async {
    if (!_tracking) return;

    _timer?.cancel();

    await _storage.saveLastActivity(DateTime.now());

    // ==========================================================
    // TODO(HYDRO SYNC):
    // Record that the application moved to the background.
    // Queue this event if offline.
    // Sync it to the backend when connectivity is available.
    // ==========================================================
  }

  Future<void> resumeTimer() async {
    if (!_tracking) return;

    if (await hasSessionExpired()) {
      onTimeout?.call();
      return;
    }

    await resetTimer();
  }

  Future<bool> hasSessionExpired() async {
    final lastActivity = await _storage.getLastActivity();

    if (lastActivity == null) return false;

    return DateTime.now().difference(lastActivity) >= timeout;
  }

  Future<void> stop() async {
    _tracking = false;
    _timer?.cancel();
    await _storage.clearLastActivity();

    // ==========================================================
    // TODO(HYDRO SYNC):
    // Sync any pending offline activities before clearing
    // local session data if required by business rules.
    // ==========================================================
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer(timeout, () {
      // ==========================================================
      // TODO(HYDRO SYNC):
      // Send "session timeout" event to the backend.
      // If offline, store it locally and let SyncService upload
      // it when the device reconnects.
      // ==========================================================

      onTimeout?.call();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
