import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../bloc/projects/projects_bloc.dart';
import '../../bloc/projects/projects_event.dart';
import '../../bloc/projects/projects_state.dart';
import '../../widgets/common/section_title.dart';
import 'widgets/project_card.dart';
import 'widgets/project_filter.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
                title: AppStrings.projectsTitle,
                subtitle: AppStrings.projectsSubtitle,
              ),
              const SizedBox(height: 32),

              // Filter
              BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (context, state) {
                  return ProjectFilter(
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (category) {
                      context.read<ProjectsBloc>().add(FilterProjectsEvent(category));
                    },
                  ).animate().fadeIn(duration: 500.ms);
                },
              ),

              const SizedBox(height: 32),

              // Projects Grid
              BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (context, state) {
                  if (state.filteredProjects.isEmpty) {
                    return const Center(
                      child: Text('No projects found'),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate proper aspect ratio based on available width
                      final cardWidth = isMobile
                          ? constraints.maxWidth
                          : isTablet
                              ? (constraints.maxWidth - AppDimensions.spacingLg) / 2
                              : (constraints.maxWidth - AppDimensions.spacingLg * 2) / 3;
                      final cardHeight = isMobile ? cardWidth * 0.9 : cardWidth * 1.15;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                          mainAxisSpacing: AppDimensions.spacingLg,
                          crossAxisSpacing: AppDimensions.spacingLg,
                          childAspectRatio: cardWidth / cardHeight,
                        ),
                        itemCount: state.filteredProjects.length,
                        itemBuilder: (context, index) {
                          final project = state.filteredProjects[index];
                          return ProjectCard(
                            project: project,
                            index: index,
                          ).animate(delay: Duration(milliseconds: index * 100))
                            .fadeIn(duration: 500.ms)
                            .scale(begin: const Offset(0.95, 0.95));
                        },
                      );
                    },
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
