import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_helper.dart';

/// A shimmer effect widget that creates a loading animation
class ShimmerEffect extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const ShimmerEffect({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final highlightColor = isDark
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
            borderRadius: widget.shape == BoxShape.circle ? null : widget.borderRadius,
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

/// A skeleton box placeholder with shimmer effect
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusSm),
    );
  }
}

/// A skeleton line placeholder (for text)
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
    );
  }
}

/// A skeleton circle placeholder (for avatars, icons)
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }
}

/// Skeleton placeholder for a skill category card
class SkillCardSkeleton extends StatelessWidget {
  const SkillCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon placeholder
          const SkeletonCircle(size: 48),
          const SizedBox(height: 16),
          // Title placeholder
          const SkeletonLine(width: 120, height: 20),
          const SizedBox(height: 16),
          // Skills chips placeholders
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                5,
                (index) => SkeletonBox(
                  width: 60 + (index % 3) * 20,
                  height: 28,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton placeholder for an experience timeline item
class ExperienceCardSkeleton extends StatelessWidget {
  final bool isLast;
  final double dotSize;
  final double timelineWidth;

  const ExperienceCardSkeleton({
    super.key,
    this.isLast = false,
    this.dotSize = 26,
    this.timelineWidth = 70,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : (isMobile ? 20 : 24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot skeleton
          SizedBox(
            width: timelineWidth,
            child: Center(
              child: SkeletonCircle(size: dotSize),
            ),
          ),
          // Card content skeleton
          Expanded(
            child: Container(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role title
                  SkeletonLine(width: isMobile ? 180 : 250, height: 22),
                  const SizedBox(height: 8),
                  // Company name
                  const SkeletonLine(width: 150, height: 18),
                  const SizedBox(height: 16),
                  // Meta info (duration, location)
                  Row(
                    children: [
                      const SkeletonLine(width: 100, height: 14),
                      const SizedBox(width: 16),
                      const SkeletonLine(width: 80, height: 14),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Responsibility lines
                  const SkeletonLine(height: 14),
                  const SizedBox(height: 8),
                  const SkeletonLine(width: double.infinity, height: 14),
                  const SizedBox(height: 8),
                  SkeletonLine(width: isMobile ? 200 : 300, height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton placeholder for a project card
class ProjectCardSkeleton extends StatelessWidget {
  const ProjectCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image placeholder
            const SkeletonBox(
              height: 80,
              borderRadius: BorderRadius.zero,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const SkeletonLine(width: 160, height: 20),
                    const SizedBox(height: 8),
                    // Subtitle
                    const SkeletonLine(width: 100, height: 14),
                    SizedBox(height: isMobile ? 12 : 16),
                    // Description lines
                    const SkeletonLine(height: 12),
                    const SizedBox(height: 6),
                    const SkeletonLine(height: 12),
                    const SizedBox(height: 6),
                    const SkeletonLine(width: 180, height: 12),
                    const Spacer(),
                    // Tech stack chips
                    Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: SkeletonBox(
                            width: 50 + (index * 10),
                            height: 24,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    // View details link
                    const SkeletonLine(width: 90, height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a contact form field
class ContactFieldSkeleton extends StatelessWidget {
  final double height;

  const ContactFieldSkeleton({
    super.key,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      height: height,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    );
  }
}

/// Skeleton placeholder for the contact section
class ContactSectionSkeleton extends StatelessWidget {
  const ContactSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      children: [
        // Section title skeleton
        const _SectionTitleSkeleton(),
        SizedBox(height: isMobile ? 32 : 48),
        // Form fields
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Name field
              const ContactFieldSkeleton(),
              const SizedBox(height: 16),
              // Email field
              const ContactFieldSkeleton(),
              const SizedBox(height: 16),
              // Subject field
              const ContactFieldSkeleton(),
              const SizedBox(height: 16),
              // Message field (taller)
              const ContactFieldSkeleton(height: 150),
              const SizedBox(height: 24),
              // Submit button
              SkeletonBox(
                width: isMobile ? double.infinity : 200,
                height: 48,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Skeleton for section title
class _SectionTitleSkeleton extends StatelessWidget {
  const _SectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SkeletonLine(width: 200, height: 32),
        const SizedBox(height: 12),
        const SkeletonLine(width: 300, height: 16),
      ],
    );
  }
}

/// Complete skeleton placeholder for skills section
class SkillsSectionSkeleton extends StatelessWidget {
  final double height;

  const SkillsSectionSkeleton({
    super.key,
    this.height = 600,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: height,
      padding: ResponsiveHelper.sectionPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.contentMaxWidth(context),
          ),
          child: Column(
            children: [
              const _SectionTitleSkeleton(),
              const SizedBox(height: 48),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
                    final spacing = AppDimensions.spacingLg;
                    final itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
                    final cardHeight = isMobile ? 180.0 : (isTablet ? 200.0 : 220.0);

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: isMobile ? constraints.maxWidth : itemWidth,
                          height: cardHeight,
                          child: const SkillCardSkeleton(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Complete skeleton placeholder for experience section
class ExperienceSectionSkeleton extends StatelessWidget {
  final double height;

  const ExperienceSectionSkeleton({
    super.key,
    this.height = 800,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final timelineWidth = isMobile ? 50.0 : 70.0;
    final dotSize = isMobile ? 20.0 : 26.0;

    return Container(
      height: height,
      padding: ResponsiveHelper.sectionPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.contentMaxWidth(context),
          ),
          child: Column(
            children: [
              const _SectionTitleSkeleton(),
              SizedBox(height: isMobile ? 32 : 48),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => ExperienceCardSkeleton(
                        isLast: index == 2,
                        dotSize: dotSize,
                        timelineWidth: timelineWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Complete skeleton placeholder for projects section
class ProjectsSectionSkeleton extends StatelessWidget {
  final double height;

  const ProjectsSectionSkeleton({
    super.key,
    this.height = 700,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: height,
      padding: ResponsiveHelper.sectionPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.contentMaxWidth(context),
          ),
          child: Column(
            children: [
              const _SectionTitleSkeleton(),
              const SizedBox(height: 24),
              // Filter tabs skeleton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SkeletonBox(
                      width: 80,
                      height: 36,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Project cards grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
                    final spacing = AppDimensions.spacingMd;
                    final itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
                    final cardHeight = isMobile ? 320.0 : 340.0;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: List.generate(
                        isMobile ? 2 : 6,
                        (index) => SizedBox(
                          width: isMobile ? constraints.maxWidth : itemWidth,
                          height: cardHeight,
                          child: const ProjectCardSkeleton(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Complete skeleton placeholder for contact section
class ContactSectionSkeletonWrapper extends StatelessWidget {
  final double height;

  const ContactSectionSkeletonWrapper({
    super.key,
    this.height = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: ResponsiveHelper.sectionPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.contentMaxWidth(context),
            maxHeight: height - 48, // Account for padding
          ),
          child: const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: ContactSectionSkeleton(),
          ),
        ),
      ),
    );
  }
}
