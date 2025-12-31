import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../bloc/navigation/navigation_bloc.dart';
import '../../bloc/navigation/navigation_state.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_state.dart';

class MobileDrawer extends StatelessWidget {
  final Function(int) onItemTap;

  const MobileDrawer({
    super.key,
    required this.onItemTap,
  });

  static const List<String> navItems = [
    AppStrings.navHome,
    AppStrings.navAbout,
    AppStrings.navSkills,
    AppStrings.navExperience,
    AppStrings.navProjects,
    AppStrings.navContact,
  ];

  static const List<IconData> navIcons = [
    Icons.home_outlined,
    Icons.person_outline,
    Icons.code_outlined,
    Icons.work_outline,
    Icons.folder_outlined,
    Icons.email_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: BoxDecoration(
            color: themeState.isDarkMode
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Nav Items
              BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, navState) {
                  return Column(
                    children: List.generate(
                      navItems.length,
                      (index) => _buildNavItem(
                        context,
                        index,
                        navItems[index],
                        navIcons[index],
                        navState.currentSection == index,
                      ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: -0.1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ).animate().slideY(begin: 0.3, end: 0, duration: 300.ms);
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String label,
    IconData icon,
    bool isActive,
  ) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onItemTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isActive
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.textTheme.titleMedium?.color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
