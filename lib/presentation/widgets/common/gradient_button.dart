import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_helper.dart';
import '../cursor/cursor_provider.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;
  final double? width;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.width,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isHovered = false;

  void _onEnter(BuildContext context) {
    setState(() => _isHovered = true);
    if (kIsWeb) CursorScope.maybeOf(context)?.setState(CursorState.hovering);
  }

  void _onExit(BuildContext context) {
    setState(() => _isHovered = false);
    if (kIsWeb) CursorScope.maybeOf(context)?.setState(CursorState.normal);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return MouseRegion(
      onEnter: (_) => _onEnter(context),
      onExit: (_) => _onExit(context),
      cursor: kIsWeb ? SystemMouseCursors.none : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 28,
            vertical: isMobile ? 12 : 16,
          ),
          decoration: BoxDecoration(
            gradient: widget.isOutlined
                ? null
                : (_isHovered
                    ? AppColors.accentGradient
                    : AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(12),
            border: widget.isOutlined
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: _isHovered && !widget.isOutlined
                ? [
                    BoxShadow(
                      color: AppColors.darkPrimary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          transform: _isHovered
              ? (Matrix4.identity()..setTranslationRaw(0.0, -2.0, 0.0))
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.isOutlined
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  size: isMobile ? 16 : 20,
                ),
                SizedBox(width: isMobile ? 8 : 10),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.isOutlined
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
