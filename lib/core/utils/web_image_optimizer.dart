import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';

/// Web-optimized image widget with lazy loading and format optimization.
/// Features:
/// - Lazy loading: Only loads images when they become visible
/// - Responsive sizing: Requests appropriate image size for device
/// - Placeholder support: Shows skeleton while loading
/// - Error handling: Graceful fallback on load failure
class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final bool enableLazyLoading;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.semanticLabel,
    this.enableLazyLoading = true,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage> {
  bool _shouldLoad = false;
  bool _hasBeenVisible = false;

  @override
  void initState() {
    super.initState();
    // Disable lazy loading on non-web platforms for better UX
    if (!kIsWeb || !widget.enableLazyLoading) {
      _shouldLoad = true;
      _hasBeenVisible = true;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasBeenVisible) return;

    if (info.visibleFraction > 0) {
      setState(() {
        _shouldLoad = true;
        _hasBeenVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Skip visibility detection if lazy loading disabled or non-web
    if (!kIsWeb || !widget.enableLazyLoading || _hasBeenVisible) {
      return _buildImage(isDark);
    }

    return VisibilityDetector(
      key: Key('opt_img_${widget.imageUrl.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: _shouldLoad
          ? _buildImage(isDark)
          : _buildPlaceholder(isDark),
    );
  }

  Widget _buildImage(bool isDark) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: _getOptimizedUrl(),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        placeholder: (context, url) =>
            widget.placeholder ?? _buildPlaceholder(isDark),
        errorWidget: (context, url, error) =>
            widget.errorWidget ?? _buildErrorWidget(isDark),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        memCacheWidth: _getCacheWidth(),
        memCacheHeight: _getCacheHeight(),
      ),
    );
  }

  /// Get optimized URL with size parameters if supported
  String _getOptimizedUrl() {
    // Add image CDN resize parameters if applicable
    // This works with services like Cloudinary, imgix, etc.
    final url = widget.imageUrl;

    // Example: Add width parameter for image CDNs
    // Modify this based on your image hosting service
    if (widget.width != null && _isResizableUrl(url)) {
      final devicePixelRatio =
          WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
      final targetWidth = (widget.width! * devicePixelRatio).round();
      return _appendSizeParam(url, targetWidth);
    }

    return url;
  }

  bool _isResizableUrl(String url) {
    // Check if URL is from a service that supports resize params
    return url.contains('cloudinary.com') ||
           url.contains('imgix.net') ||
           url.contains('imagekit.io');
  }

  String _appendSizeParam(String url, int width) {
    if (url.contains('cloudinary.com')) {
      // Cloudinary format
      return url.replaceFirst('/upload/', '/upload/w_$width,f_auto,q_auto/');
    } else if (url.contains('imgix.net')) {
      // imgix format
      final separator = url.contains('?') ? '&' : '?';
      return '$url${separator}w=$width&auto=format,compress';
    }
    return url;
  }

  int? _getCacheWidth() {
    if (widget.width == null) return null;
    final ratio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return (widget.width! * ratio).round().clamp(100, 1200);
  }

  int? _getCacheHeight() {
    if (widget.height == null) return null;
    final ratio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return (widget.height! * ratio).round().clamp(100, 1200);
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurfaceVariant,
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(bool isDark) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurfaceVariant,
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: (widget.height ?? 48) * 0.3,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),
    );
  }
}

/// Utility class for image optimization hints
class ImageOptimizationConfig {
  /// Maximum memory cache size in bytes (default: 100MB)
  static const int maxMemoryCacheSize = 100 * 1024 * 1024;

  /// Maximum disk cache size in bytes (default: 500MB)
  static const int maxDiskCacheSize = 500 * 1024 * 1024;

  /// Default image quality for resized images
  static const int defaultQuality = 85;

  /// Whether to prefer WebP format when available
  static const bool preferWebP = true;

  /// Get responsive image width based on screen size
  static int getResponsiveWidth(BuildContext context, double percentage) {
    final screenWidth = MediaQuery.of(context).size.width;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return ((screenWidth * percentage) * devicePixelRatio).round();
  }
}

/// Extension to add optimization hints to Image widgets
extension ImageOptimization on Image {
  /// Creates an optimized version of the image for web
  static Widget optimized({
    required String url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return OptimizedImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}
