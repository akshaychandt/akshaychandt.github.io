import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Web-specific performance utilities for Flutter web optimization.
/// These utilities help improve load times, reduce bundle size impact,
/// and provide better user experience on web platforms.
class WebPerformance {
  WebPerformance._();

  static bool _initialized = false;

  /// Initialize web performance optimizations.
  /// Call this early in app startup (e.g., in main.dart).
  static void initialize() {
    if (_initialized || !kIsWeb) return;
    _initialized = true;

    // Schedule non-critical work for after first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _runDeferredInitialization();
    });
  }

  static void _runDeferredInitialization() {
    // Placeholder for deferred initialization tasks
    // Add any heavy initialization that can be delayed
  }

  /// Check if the app is running on a low-end device.
  /// Useful for disabling heavy animations or effects.
  static bool get isLowEndDevice {
    if (!kIsWeb) return false;

    // On web, we can check navigator.hardwareConcurrency
    // For now, return false as we can't directly access this from Dart
    // Consider using js_interop for more accurate detection
    return false;
  }

  /// Get recommended animation duration based on device capability.
  /// Returns shorter durations for potentially slower devices.
  static Duration getAnimationDuration(Duration defaultDuration) {
    if (isLowEndDevice) {
      return Duration(
        milliseconds: (defaultDuration.inMilliseconds * 0.5).round(),
      );
    }
    return defaultDuration;
  }

  /// Reduce animation complexity on web for better performance.
  /// Returns true if complex animations should be simplified.
  static bool get shouldSimplifyAnimations {
    // On web, some complex animations may cause jank
    // This can be used to conditionally disable particle effects, etc.
    return kIsWeb && isLowEndDevice;
  }
}

/// Mixin for widgets that need web-optimized rendering.
/// Provides utilities for conditional rendering based on platform.
mixin WebOptimizedWidget {
  /// Whether the widget is running on web platform.
  bool get isWeb => kIsWeb;

  /// Get a simplified version of a widget for web if needed.
  T getOptimized<T>({required T standard, required T simplified}) {
    if (WebPerformance.shouldSimplifyAnimations) {
      return simplified;
    }
    return standard;
  }
}

/// Utility for scheduling work at appropriate times.
class WorkScheduler {
  WorkScheduler._();

  /// Schedule work to run after the current frame.
  static void scheduleAfterFrame(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  /// Schedule work to run when idle (best effort).
  /// On web, this helps avoid blocking the main thread.
  static void scheduleWhenIdle(VoidCallback callback) {
    if (kIsWeb) {
      // Use a small delay to allow browser to process other events
      Future.delayed(const Duration(milliseconds: 16), callback);
    } else {
      // On native platforms, run immediately after frame
      scheduleAfterFrame(callback);
    }
  }

  /// Schedule multiple callbacks with staggered delays.
  /// Useful for loading multiple resources without blocking.
  static void scheduleStaggered(
    List<VoidCallback> callbacks, {
    Duration delay = const Duration(milliseconds: 50),
  }) {
    for (int i = 0; i < callbacks.length; i++) {
      Future.delayed(delay * i, callbacks[i]);
    }
  }
}

/// Configuration for web-specific optimizations.
class WebOptimizationConfig {
  /// Whether to enable deferred loading of sections.
  static const bool enableDeferredLoading = true;

  /// Whether to enable lazy loading of images.
  static const bool enableLazyImages = true;

  /// Threshold (in pixels) before viewport when content should start loading.
  static const double preloadThreshold = 200.0;

  /// Maximum concurrent image loads on web.
  static const int maxConcurrentImageLoads = 4;

  /// Whether to enable reduced motion for accessibility.
  static bool get prefersReducedMotion {
    // This would ideally check the browser's prefers-reduced-motion setting
    // For now, return false as we need js_interop for accurate detection
    return false;
  }
}

/// Analytics for web performance monitoring.
class PerformanceAnalytics {
  PerformanceAnalytics._();

  static final Map<String, int> _timings = {};

  /// Mark the start of a performance measurement.
  static void markStart(String label) {
    _timings[label] = DateTime.now().millisecondsSinceEpoch;
  }

  /// Mark the end and calculate duration.
  /// Returns duration in milliseconds, or null if start wasn't marked.
  static int? markEnd(String label) {
    final startTime = _timings[label];
    if (startTime == null) return null;

    final duration = DateTime.now().millisecondsSinceEpoch - startTime;
    _timings.remove(label);

    if (kDebugMode) {
      // ignore: avoid_print
      print('Performance [$label]: ${duration}ms');
    }

    return duration;
  }

  /// Get all current timing labels.
  static Set<String> get activeTimings => _timings.keys.toSet();

  /// Clear all timings.
  static void clear() => _timings.clear();
}
