import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A widget that defers loading of its child until it becomes visible.
/// This is particularly useful for web optimization to reduce initial bundle size
/// and improve first contentful paint.
class DeferredLoader extends StatefulWidget {
  /// The child widget to load when visible
  final Widget child;

  /// Placeholder widget shown before the child is loaded
  final Widget? placeholder;

  /// Minimum height for the placeholder to prevent layout shifts
  final double? placeholderHeight;

  /// Visibility threshold (0.0 to 1.0) to trigger loading
  /// Default is 0.0 meaning any visibility triggers loading
  final double visibilityThreshold;

  /// Whether to keep the child alive after it's been loaded
  final bool keepAlive;

  /// Unique key for the visibility detector
  final String detectorKey;

  /// Optional delay before loading starts (helps with scroll performance)
  final Duration loadDelay;

  const DeferredLoader({
    super.key,
    required this.child,
    required this.detectorKey,
    this.placeholder,
    this.placeholderHeight,
    this.visibilityThreshold = 0.0,
    this.keepAlive = true,
    this.loadDelay = Duration.zero,
  });

  @override
  State<DeferredLoader> createState() => _DeferredLoaderState();
}

class _DeferredLoaderState extends State<DeferredLoader> {
  bool _shouldLoad = false;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    // On non-web platforms, load immediately for better native performance
    if (!kIsWeb) {
      _shouldLoad = true;
      _hasLoaded = true;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasLoaded && widget.keepAlive) return;

    final visiblePercentage = info.visibleFraction;
    if (visiblePercentage > widget.visibilityThreshold && !_shouldLoad) {
      if (widget.loadDelay == Duration.zero) {
        _triggerLoad();
      } else {
        Future.delayed(widget.loadDelay, () {
          if (mounted) _triggerLoad();
        });
      }
    }
  }

  void _triggerLoad() {
    if (!mounted || _shouldLoad) return;
    setState(() {
      _shouldLoad = true;
      _hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Skip visibility detection on non-web platforms
    if (!kIsWeb) {
      return widget.child;
    }

    // If already loaded, just return the child directly
    if (_shouldLoad) {
      return widget.child;
    }

    // Show placeholder with visibility detection
    return VisibilityDetector(
      key: Key(widget.detectorKey),
      onVisibilityChanged: _onVisibilityChanged,
      child: widget.placeholder ?? _buildDefaultPlaceholder(),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return SizedBox(
      height: widget.placeholderHeight ?? 400,
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

/// A lightweight placeholder for deferred sections
/// that maintains layout while content loads
class SectionPlaceholder extends StatelessWidget {
  final double height;
  final String? label;

  const SectionPlaceholder({
    super.key,
    this.height = 400,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withValues(alpha: 0.3)
            : Colors.grey.shade100.withValues(alpha: 0.3),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? Colors.white54 : Colors.black38,
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: 12),
              Text(
                label!,
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black26,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Utility to preload deferred content when idle
class DeferredPreloader {
  static final Set<String> _preloadedKeys = {};

  /// Schedule preloading of content during idle time
  static void schedulePreload(String key, VoidCallback preloadAction) {
    if (_preloadedKeys.contains(key)) return;

    // Use addPostFrameCallback to schedule during idle time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_preloadedKeys.contains(key)) {
        _preloadedKeys.add(key);
        preloadAction();
      }
    });
  }

  /// Check if content has been preloaded
  static bool isPreloaded(String key) => _preloadedKeys.contains(key);

  /// Clear preload cache (useful for hot reload)
  static void clearCache() => _preloadedKeys.clear();
}
