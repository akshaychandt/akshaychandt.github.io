import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/email_service.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../widgets/common/section_title.dart';
import '../../widgets/common/gradient_button.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
                title: AppStrings.contactTitle,
                subtitle: AppStrings.contactSubtitle,
              ),
              const SizedBox(height: 48),
              isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _buildContactInfo(context)),
          const SizedBox(width: 48),
          Expanded(flex: 1, child: _buildContactForm(context)),
        ],
      );

  Widget _buildMobileLayout(BuildContext context) => Column(
        children: [
          _buildContactInfo(context),
          const SizedBox(height: 48),
          _buildContactForm(context),
        ],
      );

  Widget _buildContactInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's Connect",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities to be part of your visions. Feel free to reach out!",
          style: theme.textTheme.bodyLarge,
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
        const SizedBox(height: 32),
        _buildContactItem(
          context,
          FontAwesomeIcons.envelope,
          'Email',
          AppStrings.email,
          () => UrlLauncherHelper.launchEmail(AppStrings.email),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        _buildContactItem(
          context,
          FontAwesomeIcons.phone,
          'Phone',
          AppStrings.phone,
          () => UrlLauncherHelper.launchPhone(AppStrings.phone),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        _buildContactItem(
          context,
          FontAwesomeIcons.locationDot,
          'Location',
          AppStrings.location,
          null,
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideX(begin: -0.1),
        const SizedBox(height: 32),

        // Social Links
        Text(
          'Follow Me',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSocialButton(
              context,
              FontAwesomeIcons.github,
              AppStrings.githubUrl,
            ),
            const SizedBox(width: 12),
            _buildSocialButton(
              context,
              FontAwesomeIcons.linkedin,
              AppStrings.linkedinUrl,
            ),
            const SizedBox(width: 12),
            _buildSocialButton(
              context,
              FontAwesomeIcons.instagram,
              AppStrings.instagramUrl,
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon, String url) =>
      _AnimatedSocialButton(icon: icon, url: url);

  Widget _buildContactForm(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Message',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: AppStrings.contactFormName,
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: AppStrings.contactFormEmail,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: AppStrings.contactFormMessage,
                prefixIcon: Icon(Icons.message_outlined),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GradientButton(
                      text: AppStrings.contactFormSubmit,
                      icon: Icons.send,
                      onPressed: _submitForm,
                    ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await EmailService.sendEmail(
        name: _nameController.text,
        email: _emailController.text,
        message: _messageController.text,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result.isSuccess) {
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.contactFormSuccess),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Failed to send message'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _AnimatedSocialButton extends StatefulWidget {
  final IconData icon;
  final String url;

  const _AnimatedSocialButton({required this.icon, required this.url});

  @override
  State<_AnimatedSocialButton> createState() => _AnimatedSocialButtonState();
}

class _AnimatedSocialButtonState extends State<_AnimatedSocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => UrlLauncherHelper.launchURL(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: 1,
            ),
          ),
          transform: _isHovered
              ? (Matrix4.identity()..setTranslationRaw(0.0, -4.0, 0.0))
              : Matrix4.identity(),
          child: FaIcon(
            widget.icon,
            size: 20,
            color: _isHovered
                ? theme.colorScheme.primary
                : theme.iconTheme.color,
          ),
        ),
      ),
    );
  }
}
