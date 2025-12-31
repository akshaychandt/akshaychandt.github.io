import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/resume_data.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../widgets/common/section_title.dart';
import 'widgets/skill_category_card.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
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
              const SectionTitle(
                title: AppStrings.skillsTitle,
                subtitle: AppStrings.skillsSubtitle,
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
                  final spacing = AppDimensions.spacingLg;
                  final itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

                  // Responsive card height
                  final cardHeight = isMobile ? 180.0 : (isTablet ? 200.0 : 220.0);

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: ResumeData.skillCategories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;
                      return SizedBox(
                        width: isMobile ? constraints.maxWidth : itemWidth,
                        height: cardHeight,
                        child: SkillCategoryCard(
                          category: category,
                          index: index,
                        ).animate(delay: Duration(milliseconds: index * 100))
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
