import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../widgets/common/gradient_button.dart';
import 'widgets/particle_background.dart';
import 'widgets/social_links.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onViewWorkPressed;
  final VoidCallback? onDownloadResumePressed;

  const HeroSection({
    super.key,
    this.onViewWorkPressed,
    this.onDownloadResumePressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = ResponsiveHelper.isMobile(context);
    final navbarHeight = isMobile
        ? AppDimensions.navbarMobileHeight
        : AppDimensions.navbarHeight;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: screenHeight - navbarHeight),
      child: Stack(
        children: [
          // Particle Background
          const Positioned.fill(child: ParticleBackground()),

          // Content
          Center(
            child: Padding(
              padding: ResponsiveHelper.sectionPadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.contentMaxWidth(context),
                ),
                child: isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
              ),
            ),
          ),

          // Scroll Indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(child: _buildScrollIndicator(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 3, child: _buildHeroContent(context)),
        const SizedBox(width: 48),
        Expanded(flex: 2, child: _buildProfileImage(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProfileImage(context, size: 120),
        const SizedBox(height: 16),
        _buildHeroContent(context, centerAlign: true),
      ],
    );
  }

  Widget _buildHeroContent(BuildContext context, {bool centerAlign = false}) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerAlign
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Greeting
        Text(
          AppStrings.heroGreeting,
          style:
              (isMobile
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.titleLarge)
                  ?.copyWith(color: theme.colorScheme.primary),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2),

        SizedBox(height: isMobile ? 4 : 8),

        // Name
        Text(
          AppStrings.name,
          style:
              (isMobile
                      ? theme.textTheme.headlineMedium
                      : theme.textTheme.displayMedium)
                  ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: centerAlign ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideX(begin: -0.2),

        SizedBox(height: isMobile ? 8 : 16),

        // Animated Role
        SizedBox(
          height: isMobile ? 35 : 50,
          child: DefaultTextStyle(
            style:
                (isMobile
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.headlineSmall)!
                    .copyWith(color: theme.colorScheme.secondary),
            textAlign: centerAlign ? TextAlign.center : TextAlign.start,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: AppStrings.animatedRoles.map((role) {
                return TypewriterAnimatedText(
                  role,
                  speed: const Duration(milliseconds: 100),
                );
              }).toList(),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

        SizedBox(height: isMobile ? 16 : 24),

        // Subtitle
        Text(
          AppStrings.heroSubtitle,
          style: isMobile
              ? theme.textTheme.bodyMedium
              : theme.textTheme.bodyLarge,
          textAlign: centerAlign ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

        SizedBox(height: isMobile ? 20 : 32),

        // CTA Buttons
        Wrap(
          alignment: centerAlign ? WrapAlignment.center : WrapAlignment.start,
          spacing: isMobile ? 12 : 16,
          runSpacing: isMobile ? 12 : 16,
          children: [
            GradientButton(
                  text: AppStrings.heroCtaPrimary,
                  icon: FontAwesomeIcons.briefcase,
                  onPressed: onViewWorkPressed ?? () {},
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 500.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            GradientButton(
                  text: AppStrings.heroCtaSecondary,
                  icon: FontAwesomeIcons.download,
                  isOutlined: true,
                  onPressed: onDownloadResumePressed ?? () {},
                )
                .animate()
                .fadeIn(delay: 900.ms, duration: 500.ms)
                .scale(begin: const Offset(0.8, 0.8)),
          ],
        ),

        SizedBox(height: isMobile ? 20 : 32),

        // Social Links
        const SocialLinks().animate().fadeIn(delay: 1000.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context, {double? size}) {
    final imageSize =
        size ??
        ResponsiveHelper.responsiveValue(
          context,
          mobile: AppDimensions.profileImageSizeMobile,
          desktop: AppDimensions.profileImageSizeDesktop,
        );
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final profileImage = isDarkMode
        ? 'assets/images/profile_dark.jpg'
        : 'assets/images/profile_light.jpg';

    return Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.darkPrimary.withValues(alpha: 0.4),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.all(4),
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              transitionBuilder: (child, animation) {
                // 3D coin flip - rotate only 90 degrees so image never appears mirrored
                final rotateAnimation = Tween<double>(begin: 0.5, end: 0.0)
                    .animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    );

                return AnimatedBuilder(
                  animation: rotateAnimation,
                  builder: (context, _) {
                    final angle =
                        rotateAnimation.value *
                        3.14159; // 0 to PI/2 (90 degrees)

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: Opacity(opacity: animation.value, child: child),
                    );
                  },
                );
              },
              child: Container(
                key: ValueKey<String>(profileImage),
                width: imageSize - 16,
                height: imageSize - 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildScrollIndicator(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Scroll Down', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        Container(
          width: 24,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child:
                Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 4,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: 12,
                      duration: 1500.ms,
                      curve: Curves.easeInOut,
                    ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1200.ms, duration: 500.ms);
  }
}
