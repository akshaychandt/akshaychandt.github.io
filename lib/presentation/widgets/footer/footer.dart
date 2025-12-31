import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_launcher_helper.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(
          context,
          mobile: 24,
          tablet: 48,
          desktop: 80,
        ),
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.contentMaxWidth(context),
          ),
          child: isMobile
              ? _buildMobileFooter(context)
              : _buildDesktopFooter(context),
        ),
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo and copyright
        Row(
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
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppStrings.footerCopyright,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),

        // Built with
        Row(
          children: [
            Text(
              AppStrings.footerBuiltWith,
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const FaIcon(
                FontAwesomeIcons.flutter,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 16,
            ),
          ],
        ),

        // Social links
        Row(
          children: [
            _buildFooterSocialButton(
              context,
              FontAwesomeIcons.github,
              AppStrings.githubUrl,
            ),
            const SizedBox(width: 12),
            _buildFooterSocialButton(
              context,
              FontAwesomeIcons.linkedin,
              AppStrings.linkedinUrl,
            ),
            const SizedBox(width: 12),
            _buildFooterSocialButton(
              context,
              FontAwesomeIcons.envelope,
              'mailto:${AppStrings.email}',
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildMobileFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Logo
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Social links
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterSocialButton(
              context,
              FontAwesomeIcons.github,
              AppStrings.githubUrl,
            ),
            const SizedBox(width: 12),
            _buildFooterSocialButton(
              context,
              FontAwesomeIcons.linkedin,
              AppStrings.linkedinUrl,
            ),
            const SizedBox(width: 12),
            _buildFooterSocialButton(
              context,
              FontAwesomeIcons.envelope,
              'mailto:${AppStrings.email}',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Built with
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.footerBuiltWith,
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(width: 4),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const FaIcon(
                FontAwesomeIcons.flutter,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 12,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.footerCopyright,
          style: theme.textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildFooterSocialButton(
      BuildContext context, IconData icon, String url) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => UrlLauncherHelper.launchURL(url),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
