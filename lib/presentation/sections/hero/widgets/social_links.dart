import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../widgets/cursor/cursor_provider.dart';

class SocialLinks extends StatelessWidget {
  final bool showLabels;
  final double iconSize;

  const SocialLinks({
    super.key,
    this.showLabels = false,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _SocialButton(
          icon: FontAwesomeIcons.github,
          label: 'GitHub',
          url: AppStrings.githubUrl,
          showLabel: showLabels,
          iconSize: iconSize,
        ),
        _SocialButton(
          icon: FontAwesomeIcons.linkedin,
          label: 'LinkedIn',
          url: AppStrings.linkedinUrl,
          showLabel: showLabels,
          iconSize: iconSize,
        ),
        _SocialButton(
          icon: FontAwesomeIcons.envelope,
          label: 'Email',
          url: 'mailto:${AppStrings.email}',
          showLabel: showLabels,
          iconSize: iconSize,
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool showLabel;
  final double iconSize;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.showLabel,
    required this.iconSize,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  void _onEnter(BuildContext context) {
    setState(() => _isHovered = true);
    if (kIsWeb) {
      final provider = CursorScope.maybeOf(context);
      provider?.setState(CursorState.link);
    }
  }

  void _onExit(BuildContext context) {
    setState(() => _isHovered = false);
    if (kIsWeb) {
      final provider = CursorScope.maybeOf(context);
      provider?.setState(CursorState.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _onEnter(context),
      onExit: (_) => _onExit(context),
      cursor: kIsWeb ? SystemMouseCursors.none : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => UrlLauncherHelper.launchSocialLink(widget.label, widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(widget.showLabel ? 12 : 14),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: widget.iconSize,
                color: _isHovered
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
              if (widget.showLabel) ...[
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _isHovered
                        ? theme.colorScheme.primary
                        : theme.textTheme.labelMedium?.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
