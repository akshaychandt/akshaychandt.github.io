import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/resume_data.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/experience_model.dart';
import '../../widgets/common/section_title.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final timelineWidth = isMobile ? 50.0 : 70.0;
    final dotSize = isMobile ? 20.0 : 26.0;

    return Container(
      padding: ResponsiveHelper.sectionPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.contentMaxWidth(context),
          ),
          child: Column(
            children: [
              const SectionTitle(
                title: AppStrings.experienceTitle,
                subtitle: AppStrings.experienceSubtitle,
              ),
              SizedBox(height: isMobile ? 32 : 48),
              // Timeline items with integrated line
              Column(
                children: ResumeData.experiences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final experience = entry.value;
                  final isLast = index == ResumeData.experiences.length - 1;
                  final isFirst = index == 0;
                  return _TimelineItemWithLine(
                    experience: experience,
                    isLast: isLast,
                    isFirst: isFirst,
                    index: index,
                    dotSize: dotSize,
                    timelineWidth: timelineWidth,
                  ).animate(delay: Duration(milliseconds: index * 200))
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: index.isEven ? -0.05 : 0.05, end: 0);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItemWithLine extends StatefulWidget {
  final ExperienceModel experience;
  final bool isLast;
  final bool isFirst;
  final int index;
  final double dotSize;
  final double timelineWidth;

  const _TimelineItemWithLine({
    required this.experience,
    required this.isLast,
    required this.isFirst,
    required this.index,
    required this.dotSize,
    required this.timelineWidth,
  });

  @override
  State<_TimelineItemWithLine> createState() => _TimelineItemWithLineState();
}

class _TimelineItemWithLineState extends State<_TimelineItemWithLine> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.isLast ? 0 : (isMobile ? 20 : 24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column with dot and line using Stack
          SizedBox(
            width: widget.timelineWidth,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                // The connecting line (extends below the dot)
                if (!widget.isLast)
                  Positioned(
                    top: widget.dotSize / 2,
                    child: Container(
                      width: 3,
                      height: 500, // Large enough to cover card height
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                // The dot (on top of line)
                Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.experience.isCurrent
                        ? AppColors.primaryGradient
                        : null,
                    color: widget.experience.isCurrent
                        ? null
                        : theme.scaffoldBackgroundColor,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: widget.experience.isCurrent ? 0 : 3,
                    ),
                    boxShadow: widget.experience.isCurrent
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            // Background shadow to mask the line behind the dot
                            BoxShadow(
                              color: theme.scaffoldBackgroundColor,
                              blurRadius: 0,
                              spreadRadius: 4,
                            ),
                          ],
                  ),
                  child: widget.experience.isCurrent
                      ? Center(
                          child: Container(
                            width: isMobile ? 8 : 10,
                            height: isMobile ? 8 : 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          // Content Card
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Current badge
                    if (widget.experience.isCurrent)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Current',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    // Role
                    Text(
                      widget.experience.role,
                      style: (isMobile ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Company
                    Text(
                      widget.experience.company,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Meta info (Duration & Location)
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildMetaChip(
                          context,
                          Icons.calendar_today,
                          widget.experience.duration,
                        ),
                        _buildMetaChip(
                          context,
                          Icons.location_on,
                          widget.experience.location,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Responsibilities - show only first 2 by default
                    ...(_isExpanded
                            ? widget.experience.responsibilities
                            : widget.experience.responsibilities.take(2))
                        .map((r) => _buildResponsibility(context, r)),
                    if (widget.experience.responsibilities.length > 2)
                      GestureDetector(
                        onTap: () => setState(() => _isExpanded = !_isExpanded),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isExpanded ? 'Show Less' : 'Show More',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                                color: theme.colorScheme.primary,
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
        ],
      ),
    );
  }

  Widget _buildMetaChip(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildResponsibility(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
