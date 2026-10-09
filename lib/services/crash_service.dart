import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Centralized Firebase Crashlytics & Error Telemetry Service for Okdoz Admin Console.
class CrashService {
  CrashService._internal();
  static final CrashService instance = CrashService._internal();

  static bool _initialized = false;

  /// Initialize Crashlytics and hook global error listeners
  static Future<void> initialize({String appRole = 'admin'}) async {
    if (_initialized) return;
    _initialized = true;

    try {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

        // Catch Flutter framework errors (data tables, chart rendering exceptions)
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.presentError(details);
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
          debugPrint('[CrashService] Captured Admin framework fatal error: ${details.exceptionAsString()}');
        };

        // Catch asynchronous errors
        PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          debugPrint('[CrashService] Captured Admin async fatal error: $error');
          return true;
        };

        await FirebaseCrashlytics.instance.setCustomKey('app_role', appRole);
        await FirebaseCrashlytics.instance.setCustomKey('app_name', 'Okdoz Admin Command Center');

        debugPrint('[CrashService] Admin Crashlytics initialized.');
      } else {
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.presentError(details);
          debugPrint('[CrashService Web Admin] Framework error: ${details.exceptionAsString()}');
        };
        PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
          debugPrint('[CrashService Web Admin] Async error: $error\n$stack');
          return true;
        };
      }

      _configureGlobalErrorWidget();
    } catch (e, stack) {
      debugPrint('[CrashService] Initialization warning: $e\n$stack');
    }
  }

  static Future<void> setUserId(String? userId) async {
    if (kIsWeb) return;
    try {
      if (userId == null || userId.isEmpty) {
        await FirebaseCrashlytics.instance.setUserIdentifier('');
      } else {
        await FirebaseCrashlytics.instance.setUserIdentifier(userId);
      }
    } catch (e) {
      debugPrint('[CrashService] Failed to set admin user id: $e');
    }
  }

  static Future<void> setCustomKey(String key, Object value) async {
    if (kIsWeb) return;
    try {
      if (value is int) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is double) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is bool) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else {
        await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
      }
    } catch (e) {
      debugPrint('[CrashService] Failed to set custom key $key: $e');
    }
  }

  static void log(String message) {
    if (kIsWeb) {
      debugPrint('[CrashService Admin Breadcrumb] $message');
      return;
    }
    try {
      FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      debugPrint('[CrashService] Log warning: $e');
    }
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    debugPrint('[CrashService] Recording admin error: $exception');
    if (kIsWeb) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('[CrashService] Failed to record error: $e');
    }
  }

  static void _configureGlobalErrorWidget() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return Material(
        color: const Color(0xFF1E1E2D),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Admin Console Exception',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'An internal interface anomaly occurred. Error diagnostic telemetry has been submitted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    };
  }
}
