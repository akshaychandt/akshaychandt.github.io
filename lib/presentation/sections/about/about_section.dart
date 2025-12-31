import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../widgets/common/section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

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
                title: AppStrings.aboutTitle,
              ),
              SizedBox(height: isMobile ? 32 : 48),
              isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Bio Card
        Expanded(
          flex: 5,
          child: _buildBioCard(context),
        ),
        const SizedBox(width: 32),
        // Right: Stats + Highlights
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildStatsRow(context),
              const SizedBox(height: 24),
              _buildHighlightsCard(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildBioCard(context),
        const SizedBox(height: 24),
        _buildStatsRow(context),
        const SizedBox(height: 24),
        _buildHighlightsCard(context),
      ],
    );
  }

  Widget _buildBioCard(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Who I Am',
                style: isMobile
                    ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
                    : theme.textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            AppStrings.aboutDescription,
            style: (isMobile ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge)?.copyWith(
              height: 1.7,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.05);
  }

  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    final stats = [
      {'value': AppStrings.statYears, 'label': 'Years Exp.', 'icon': Icons.calendar_today},
      {'value': AppStrings.statApps, 'label': 'Apps Built', 'icon': Icons.apps},
      {'value': AppStrings.statMentored, 'label': 'Mentored', 'icon': Icons.people},
      {'value': AppStrings.statPlatforms, 'label': 'Platforms', 'icon': Icons.devices},
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: _buildStatItem(
              context,
              stat['value'] as String,
              stat['label'] as String,
              stat['icon'] as IconData,
              index,
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon, int index) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 10),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isMobile ? 16 : 20,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 10),
        ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
          child: Text(
            value,
            style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.headlineSmall)?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: isMobile ? 9 : 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate(delay: Duration(milliseconds: 300 + index * 100))
      .fadeIn(duration: 400.ms)
      .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildHighlightsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    final highlights = [
      {'icon': Icons.phone_android, 'title': 'Cross-Platform', 'desc': 'Flutter, Android, iOS, Web, Desktop'},
      {'icon': Icons.cloud_off, 'title': 'Offline-First', 'desc': 'SQLite, Hive, Background Sync'},
      {'icon': Icons.integration_instructions, 'title': 'SAP Integration', 'desc': 'Service Layer, Business Logic'},
      {'icon': Icons.groups, 'title': 'Team Mentor', 'desc': '15+ developers trained'},
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: theme.colorScheme.primary,
                size: isMobile ? 18 : 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Expertise',
                style: (isMobile ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          ...highlights.asMap().entries.map((entry) {
            final index = entry.key;
            final highlight = entry.value;
            return _buildHighlightItem(
              context,
              highlight['icon'] as IconData,
              highlight['title'] as String,
              highlight['desc'] as String,
              index,
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: 0.05);
  }

  Widget _buildHighlightItem(BuildContext context, IconData icon, String title, String desc, int index) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(bottom: index < 3 ? (isMobile ? 10 : 12) : 0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: isMobile ? 16 : 18,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (isMobile ? theme.textTheme.labelMedium : theme.textTheme.bodyMedium)?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  desc,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: isMobile ? 10 : 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 500 + index * 100))
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.1);
  }
}
