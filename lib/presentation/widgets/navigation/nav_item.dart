import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../cursor/cursor_provider.dart';

class NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  void _onEnter(BuildContext context) {
    setState(() => _isHovered = true);
    if (kIsWeb) CursorScope.maybeOf(context)?.setState(CursorState.link);
  }

  void _onExit(BuildContext context) {
    setState(() => _isHovered = false);
    if (kIsWeb) CursorScope.maybeOf(context)?.setState(CursorState.normal);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _onEnter(context),
      onExit: (_) => _onExit(context),
      cursor: kIsWeb ? SystemMouseCursors.none : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isActive
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : _isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.05)
                    : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: widget.isActive
                  ? theme.colorScheme.primary
                  : _isHovered
                      ? theme.colorScheme.primary
                      : theme.textTheme.labelLarge?.color,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
