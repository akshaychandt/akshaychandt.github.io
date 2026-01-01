import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../cursor/cursor_provider.dart';

class BackToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double showAfterOffset;

  const BackToTopButton({
    super.key,
    required this.scrollController,
    this.showAfterOffset = 400,
  });

  @override
  State<BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    widget.scrollController.addListener(_onScroll);
    _checkInitialPosition();
  }

  void _checkInitialPosition() {
    if (widget.scrollController.hasClients) {
      _updateVisibility(widget.scrollController.offset);
    }
  }

  void _onScroll() {
    _updateVisibility(widget.scrollController.offset);
  }

  void _updateVisibility(double offset) {
    final shouldBeVisible = offset > widget.showAfterOffset;
    if (shouldBeVisible != _isVisible) {
      setState(() => _isVisible = shouldBeVisible);
      if (shouldBeVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

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
    return Positioned(
      bottom: AppDimensions.spacingLg,
      right: AppDimensions.spacingLg,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: MouseRegion(
            onEnter: (_) => _onEnter(context),
            onExit: (_) => _onExit(context),
            cursor: kIsWeb ? SystemMouseCursors.none : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _scrollToTop,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient:
                      _isHovered ? AppColors.accentGradient : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkPrimary.withValues(alpha: _isHovered ? 0.5 : 0.3),
                      blurRadius: _isHovered ? 20 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                transform: _isHovered
                    ? (Matrix4.identity()..setTranslationRaw(0.0, -4.0, 0.0))
                    : Matrix4.identity(),
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
