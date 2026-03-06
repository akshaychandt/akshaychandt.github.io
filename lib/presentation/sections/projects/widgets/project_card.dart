import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../data/models/project_model.dart';
import '../../../widgets/cursor/cursor_provider.dart';
import '../../../widgets/skeleton/skeleton_loader.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;

  const ProjectCard({super.key, required this.project, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  void _onEnter(BuildContext context) {
    setState(() => _isHovered = true);
    if (kIsWeb) CursorScope.maybeOf(context)?.setState(CursorState.hovering);
  }

  void _onExit(BuildContext context) {
    setState(() => _isHovered = false);
    if (kIsWeb) CursorScope.maybeOf(context)?.setState(CursorState.normal);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return GestureDetector(
      onTap: () => _showProjectDetails(context),
      child: MouseRegion(
        onEnter: (_) => _onEnter(context),
        onExit: (_) => _onExit(context),
        cursor: kIsWeb ? SystemMouseCursors.none : SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : theme.dividerColor,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: isMobile ? 15 : 30,
                      offset: Offset(0, isMobile ? 8 : 15),
                    ),
                  ]
                : null,
          ),
          transform: _isHovered && !isMobile
              ? (Matrix4.identity()..setTranslationRaw(0.0, -8.0, 0.0))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Header with image or gradient
                _buildProjectHeader(theme),

                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12 : 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.project.title,
                          style:
                              (isMobile
                                      ? theme.textTheme.titleSmall
                                      : theme.textTheme.titleMedium)
                                  ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        // Subtitle
                        Text(
                          widget.project.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isMobile ? 6 : 8),

                        // Middle: Description + Feature bullets (clips silently)
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.project.description,
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: isMobile ? 6 : 8),
                                ..._buildFeatureBullets(theme, isMobile),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 4 : 6),

                        // Bottom: Tech stack (pinned)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.project.techStack
                              .take(isMobile ? 3 : 4)
                              .map((tech) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    tech,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),

                        // View Details (pinned)
                        SizedBox(height: isMobile ? 6 : 8),
                        GestureDetector(
                          onTap: () => _showProjectDetails(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Details',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureBullets(ThemeData theme, bool isMobile) {
    final featureCount = isMobile ? 2 : 3;
    final featuresToShow = widget.project.features.take(featureCount).toList();

    return featuresToShow.map((feature) {
      final displayText = _truncateFeature(feature);
      return Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayText,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.8,
                  ),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _truncateFeature(String feature) {
    // Clean up feature text for compact display
    // Remove leading verbs like "Integrated", "Implemented", "Designed", etc.
    final cleanedPatterns = [
      'Integrated ',
      'Implemented ',
      'Designed ',
      'Built ',
      'Developed ',
      'Automated ',
    ];
    String cleaned = feature;
    for (final pattern in cleanedPatterns) {
      if (cleaned.startsWith(pattern)) {
        cleaned = cleaned.substring(pattern.length);
        // Capitalize the next word
        if (cleaned.isNotEmpty) {
          cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
        }
        break;
      }
    }
    return cleaned;
  }

  Widget _buildProjectHeader(ThemeData theme) {
    final hasImage =
        widget.project.imageUrl != null && widget.project.imageUrl!.isNotEmpty;

    return SizedBox(
      height: 80,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Image or Gradient
          if (hasImage)
            CachedNetworkImage(
              imageUrl: widget.project.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const ShimmerEffect(borderRadius: BorderRadius.zero),
              errorWidget: (context, url, error) => Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: CustomPaint(painter: _PatternPainter()),
              ),
            )
          else
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: CustomPaint(painter: _PatternPainter()),
            ),

          // Dark overlay for better text readability when image is present
          if (hasImage)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),

          // Category badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getCategoryLabel(widget.project.category),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(ProjectCategory category) => switch (category) {
    ProjectCategory.crm => 'CRM',
    ProjectCategory.pos => 'POS',
    ProjectCategory.assetManagement => 'Asset Management',
    ProjectCategory.service => 'Service',
    ProjectCategory.openSource => 'Open Source',
    _ => 'Project',
  };

  void _showProjectDetails(BuildContext context) => showDialog(
    context: context,
    builder: (context) => _ProjectDetailsDialog(project: widget.project),
  );
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8 + i * 10, size.height * 0.3),
        20 + i * 15.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProjectDetailsDialog extends StatelessWidget {
  final ProjectModel project;

  const _ProjectDetailsDialog({required this.project});

  // --- Collect action descriptors ---

  List<({IconData icon, String tooltip, VoidCallback onPressed})>
  _collectActions(BuildContext context) {
    final actions =
        <({IconData icon, String tooltip, VoidCallback onPressed})>[];

    if (project.category == ProjectCategory.openSource &&
        project.liveUrl != null) {
      actions.add((
        icon: Icons.open_in_new_rounded,
        tooltip: 'View on pub.dev',
        onPressed: () => UrlLauncherHelper.launchURL(project.liveUrl!),
      ));
    }
    if (project.githubUrl != null) {
      actions.add((
        icon: Icons.code_rounded,
        tooltip: 'GitHub',
        onPressed: () => UrlLauncherHelper.launchURL(project.githubUrl!),
      ));
    }
    if (project.playStoreUrl != null) {
      actions.add((
        icon: Icons.shop_rounded,
        tooltip: 'Play Store',
        onPressed: () => UrlLauncherHelper.launchURL(project.playStoreUrl!),
      ));
    }
    if (project.appStoreUrl != null) {
      actions.add((
        icon: Icons.apple_rounded,
        tooltip: 'App Store',
        onPressed: () => UrlLauncherHelper.launchURL(project.appStoreUrl!),
      ));
    }
    if (project.playStoreUrl != null && project.appStoreUrl == null) {
      actions.add((
        icon: Icons.apple_rounded,
        tooltip: 'App Store (In Review)',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App is currently in review on App Store'),
            duration: Duration(seconds: 2),
          ),
        ),
      ));
    }
    return actions;
  }

  // --- Icon button builder ---

  Widget _buildIconAction({
    required ThemeData theme,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) => Tooltip(
    message: tooltip,
    waitDuration: const Duration(milliseconds: 400),
    child: Material(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        hoverColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
      ),
    ),
  );

  // --- Platform icon helper ---

  IconData _platformIcon(String platform) => switch (platform.toLowerCase()) {
    'android' => Icons.android_rounded,
    'ios' => Icons.apple_rounded,
    'web' => Icons.language_rounded,
    'windows' => Icons.desktop_windows_rounded,
    'macos' => Icons.laptop_mac_rounded,
    'linux' => Icons.computer_rounded,
    _ => Icons.devices_rounded,
  };

  // --- Project Info Bar ---

  Widget _buildInfoBar(ThemeData theme, bool isMobile) {
    final hasRole = project.role != null && project.role!.isNotEmpty;
    final hasDuration =
        project.duration != null && project.duration!.isNotEmpty;
    final hasPlatforms =
        project.platforms != null && project.platforms!.isNotEmpty;

    if (!hasRole && !hasDuration && !hasPlatforms) {
      return const SizedBox.shrink();
    }

    final items = <Widget>[];

    if (hasRole) {
      items.add(
        _buildInfoChip(
          theme: theme,
          icon: Icons.person_outline_rounded,
          label: project.role!,
          isMobile: isMobile,
        ),
      );
    }

    if (hasDuration) {
      items.add(
        _buildInfoChip(
          theme: theme,
          icon: Icons.calendar_today_rounded,
          label: project.duration!,
          isMobile: isMobile,
        ),
      );
    }

    if (hasPlatforms) {
      items.add(
        _buildInfoChip(
          theme: theme,
          icon: Icons.devices_rounded,
          label: project.platforms!.join(', '),
          isMobile: isMobile,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Wrap(spacing: isMobile ? 12 : 20, runSpacing: 8, children: items),
    );
  }

  Widget _buildInfoChip({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required bool isMobile,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isMobile ? 14 : 16,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style:
              (isMobile
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
        ),
      ],
    );
  }

  // --- Scrollable content items ---

  List<Widget> _buildScrollableContent(ThemeData theme, bool isMobile) {
    final content = <Widget>[];

    // Project Info Bar
    final infoBar = _buildInfoBar(theme, isMobile);
    if (infoBar is! SizedBox) {
      content.add(infoBar);
      content.add(const SizedBox(height: 20));
    }

    // Description
    content.add(Text(project.description, style: theme.textTheme.bodyLarge));
    content.add(const SizedBox(height: 24));

    // Key Features header
    content.add(
      Text(
        'Key Features',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    content.add(const SizedBox(height: 12));

    // Feature items
    content.addAll(
      project.features.map(
        (feature) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(feature, style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
      ),
    );

    // Key Highlights section
    if (project.highlights != null && project.highlights!.isNotEmpty) {
      content.add(const SizedBox(height: 24));
      content.add(
        Text(
          'Key Highlights',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      content.add(const SizedBox(height: 12));

      content.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.highlights!.map((highlight) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      highlight,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    content.add(const SizedBox(height: 24));

    // Tech Stack header
    content.add(
      Text(
        'Tech Stack',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    content.add(const SizedBox(height: 12));

    // Tech chips
    content.add(
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: project.techStack.map((tech) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              tech,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }).toList(),
      ),
    );

    // Platform Badges
    if (project.platforms != null && project.platforms!.isNotEmpty) {
      content.add(const SizedBox(height: 24));
      content.add(
        Text(
          'Platforms',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      content.add(const SizedBox(height: 12));

      content.add(
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: project.platforms!.map((platform) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _platformIcon(platform),
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    platform,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    // Bottom padding so content doesn't feel cramped
    content.add(const SizedBox(height: 16));

    return content;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = ResponsiveHelper.isMobile(context);
    final actions = _collectActions(context);

    final hasNoLinks =
        project.liveUrl == null &&
        project.githubUrl == null &&
        project.playStoreUrl == null &&
        project.appStoreUrl == null;

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: screenHeight * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── FIXED TOP: Title row + action icons + subtitle ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 24,
                isMobile ? 16 : 20,
                isMobile ? 8 : 12,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + action icons + close
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style:
                              (isMobile
                                      ? theme.textTheme.titleLarge
                                      : theme.textTheme.headlineSmall)
                                  ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Action icon buttons
                      if (actions.isNotEmpty) ...[
                        ...actions.map(
                          (a) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: _buildIconAction(
                              theme: theme,
                              icon: a.icon,
                              tooltip: a.tooltip,
                              onPressed: a.onPressed,
                            ),
                          ),
                        ),
                        // Subtle vertical divider before close
                        Container(
                          height: 24,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: theme.dividerColor,
                        ),
                      ],
                      // Enterprise badge (small icon) if no links
                      if (hasNoLinks) ...[
                        Tooltip(
                          message: 'Enterprise Distribution',
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.business_rounded,
                              size: 18,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: theme.dividerColor,
                        ),
                      ],
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.subtitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),

            // ── SCROLLABLE MIDDLE ──
            Flexible(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                    ),
                    sliver: SliverList.list(
                      children: _buildScrollableContent(theme, isMobile),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
