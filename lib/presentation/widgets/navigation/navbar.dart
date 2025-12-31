import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../bloc/navigation/navigation_bloc.dart';
import '../../bloc/navigation/navigation_event.dart';
import '../../bloc/navigation/navigation_state.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_state.dart';
import 'nav_item.dart';
import 'theme_toggle.dart';
import 'mobile_drawer.dart';

class Navbar extends StatelessWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  const Navbar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  static const List<String> navItems = [
    AppStrings.navHome,
    AppStrings.navAbout,
    AppStrings.navSkills,
    AppStrings.navExperience,
    AppStrings.navProjects,
    AppStrings.navContact,
  ];

  void _scrollToSection(BuildContext context, int index) {
    context.read<NavigationBloc>().add(NavigateToSectionEvent(index));

    if (index < sectionKeys.length) {
      final key = sectionKeys[index];
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = renderBox.localToGlobal(Offset.zero).dy;
        final currentScroll = scrollController.offset;
        final targetScroll = currentScroll + offset - AppDimensions.navbarHeight;

        scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          height: isMobile
              ? AppDimensions.navbarMobileHeight
              : AppDimensions.navbarHeight,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.responsiveValue(
              context,
              mobile: 16,
              tablet: 32,
              desktop: 48,
            ),
          ),
          decoration: BoxDecoration(
            color: themeState.isDarkMode
                ? AppColors.darkBackground.withValues(alpha: 0.95)
                : AppColors.lightBackground.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              _buildLogo(context),

              // Desktop Navigation
              if (!isMobile) ...[
                BlocBuilder<NavigationBloc, NavigationState>(
                  builder: (context, navState) {
                    return Row(
                      children: List.generate(
                        navItems.length,
                        (index) => NavItem(
                          label: navItems[index],
                          isActive: navState.currentSection == index,
                          onTap: () => _scrollToSection(context, index),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                const ThemeToggle(),
              ],

              // Mobile Menu Button
              if (isMobile)
                Row(
                  children: [
                    const ThemeToggle(),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => MobileDrawer(
                            onItemTap: (index) {
                              Navigator.pop(context);
                              _scrollToSection(context, index);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
      },
    );
  }

  Widget _buildLogo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _scrollToSection(context, 0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Akshay',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
