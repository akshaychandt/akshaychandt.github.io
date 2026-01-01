import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A reusable image widget that supports both network and asset images
/// with loading states, shimmer effects, and error handling.
class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.placeholder,
    this.errorWidget,
  }) : assert(imageUrl != null || assetPath != null,
            'Either imageUrl or assetPath must be provided');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (assetPath != null) {
      return _buildAssetImage(context);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      imageBuilder: (context, imageProvider) => _buildImageContainer(
        context,
        DecorationImage(image: imageProvider, fit: fit),
      ),
      placeholder: (context, url) =>
          placeholder ?? _buildShimmerPlaceholder(context, isDark),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(context, isDark),
    );
  }

  Widget _buildAssetImage(BuildContext context) {
    return _buildImageContainer(
      context,
      DecorationImage(
        image: AssetImage(assetPath!),
        fit: fit,
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, DecorationImage image) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        image: image,
      ),
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context, bool isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
      ),
      child: _ShimmerEffect(
        width: width,
        height: height,
        shape: shape,
        borderRadius: borderRadius,
        isDark: isDark,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, bool isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: (width ?? 48) * 0.4,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }
}

/// A shimmer loading effect widget
class _ShimmerEffect extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final bool isDark;

  const _ShimmerEffect({
    this.width,
    this.height,
    required this.shape,
    this.borderRadius,
    required this.isDark,
  });

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceVariant;
    final highlightColor = widget.isDark
        ? AppColors.darkSurface.withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius:
                widget.shape == BoxShape.circle ? null : widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// A circular cached image specifically for avatars/profile pictures
class CachedAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double size;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.assetPath,
    required this.size,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImage(
      imageUrl: imageUrl,
      assetPath: assetPath,
      width: size,
      height: size,
      shape: BoxShape.circle,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}

/// A project thumbnail image with rounded corners
class CachedProjectImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const CachedProjectImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height = 180,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // If no image provided, return gradient placeholder
    if (imageUrl == null && assetPath == null) {
      return _buildGradientPlaceholder(context);
    }

    return CachedImage(
      imageUrl: imageUrl,
      assetPath: assetPath,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
  }

  Widget _buildGradientPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.code,
        size: height * 0.3,
        color: Colors.white.withValues(alpha: 0.5),
      ),
    );
  }
}
