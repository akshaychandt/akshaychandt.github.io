import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import 'cursor_provider.dart';

/// Premium custom cursor widget with smooth animations
/// Inspired by Apple, Linear, Stripe, Vercel design language
class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({
    super.key,
    required this.child,
  });

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with TickerProviderStateMixin {
  late final CursorProvider _cursorProvider;
  late final AnimationController _clickController;
  late final AnimationController _hoverController;
  late final AnimationController _pulseController;

  // Animation values
  late Animation<double> _clickScale;
  late Animation<double> _clickOpacity;
  late Animation<double> _hoverScale;
  late Animation<double> _hoverRingSize;
  late Animation<double> _pulseAnimation;

  // Lerp factor for smooth movement (lower = smoother but more delayed)
  static const double _lerpFactor = 0.15;

  // Cursor sizes
  static const double _dotSize = 8.0;
  static const double _ringSize = 40.0;
  static const double _hoverRingSizeValue = 56.0;

  @override
  void initState() {
    super.initState();
    _cursorProvider = CursorProvider();

    // Click ripple animation
    _clickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _clickScale = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _clickController,
        curve: Curves.easeOutCubic,
      ),
    );

    _clickOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _clickController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Hover animation
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _hoverScale = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOutCubic,
      ),
    );

    _hoverRingSize = Tween<double>(begin: _ringSize, end: _hoverRingSizeValue).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Pulse animation for idle state
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the lerp loop
    _startLerpLoop();
  }

  void _startLerpLoop() {
    Future.doWhile(() async {
      if (!mounted) return false;
      _cursorProvider.lerpPosition(_lerpFactor);
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 16));
      return true;
    });
  }

  @override
  void dispose() {
    _clickController.dispose();
    _hoverController.dispose();
    _pulseController.dispose();
    _cursorProvider.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent event) {
    _cursorProvider.updatePosition(event.position);
  }

  void _onPointerDown(PointerEvent event) {
    _cursorProvider.triggerClick();
    _clickController.forward(from: 0.0);
  }

  void _onPointerExit(PointerEvent event) {
    _cursorProvider.hide();
  }

  void _onPointerEnter(PointerEvent event) {
    _cursorProvider.show();
    _cursorProvider.updatePosition(event.position);
  }

  /// Helper to create color with alpha
  Color _withAlpha(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  @override
  Widget build(BuildContext context) {
    // Only show custom cursor on web
    if (!kIsWeb) {
      return widget.child;
    }

    return CursorScope(
      provider: _cursorProvider,
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        onEnter: _onPointerEnter,
        onExit: _onPointerExit,
        child: Listener(
          onPointerMove: _onPointerMove,
          onPointerDown: _onPointerDown,
          onPointerHover: _onPointerMove,
          child: Stack(
            children: [
              widget.child,
              // Custom cursor overlay
              if (_cursorProvider.isVisible) ...[
                // Trail effect
                ..._buildTrail(context),
                // Main cursor
                _buildCursor(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTrail(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return List.generate(
      math.min(_cursorProvider.trailPositions.length, 5),
      (index) {
        if (index >= _cursorProvider.trailPositions.length) {
          return const SizedBox.shrink();
        }

        final pos = _cursorProvider.trailPositions[index];
        final opacity = (1.0 - (index / 5)) * 0.15;
        final size = _dotSize * (1.0 - (index / 10));

        return Positioned(
          left: pos.dx - size / 2,
          top: pos.dy - size / 2,
          child: IgnorePointer(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _withAlpha(baseColor, opacity),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCursor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = _cursorProvider.customColor ??
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    final position = _cursorProvider.position;
    final state = _cursorProvider.state;
    final isHovering = state == CursorState.hovering ||
        state == CursorState.link ||
        state == CursorState.text;

    // Update hover animation
    if (isHovering && !_hoverController.isAnimating && _hoverController.value < 1) {
      _hoverController.forward();
    } else if (!isHovering && !_hoverController.isAnimating && _hoverController.value > 0) {
      _hoverController.reverse();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _hoverController,
        _clickController,
        _pulseController,
      ]),
      builder: (context, child) {
        final pulseValue = _pulseAnimation.value;

        // Calculate sizes with animations
        final dotScale = _hoverScale.value;
        final ringCurrentSize = _hoverRingSize.value;
        final currentDotSize = _dotSize * dotScale;

        // Pulse effect for ring
        final pulseOffset = pulseValue * 2;

        return Stack(
          children: [
            // Outer ring with glow
            Positioned(
              left: position.dx - (ringCurrentSize + pulseOffset) / 2,
              top: position.dy - (ringCurrentSize + pulseOffset) / 2,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: ringCurrentSize + pulseOffset,
                  height: ringCurrentSize + pulseOffset,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _withAlpha(
                        primaryColor,
                        isHovering ? 0.8 : 0.4 + (pulseValue * 0.1),
                      ),
                      width: isHovering ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _withAlpha(primaryColor, 0.2),
                        blurRadius: 20,
                        spreadRadius: isHovering ? 5 : 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Inner dot
            Positioned(
              left: position.dx - currentDotSize / 2,
              top: position.dy - currentDotSize / 2,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: currentDotSize,
                  height: currentDotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isHovering
                        ? accentColor
                        : _withAlpha(primaryColor, 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: _withAlpha(
                          isHovering ? accentColor : primaryColor,
                          0.5,
                        ),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Click ripple effect
            if (_clickController.isAnimating)
              Positioned(
                left: position.dx - (_ringSize * _clickScale.value) / 2,
                top: position.dy - (_ringSize * _clickScale.value) / 2,
                child: IgnorePointer(
                  child: Container(
                    width: _ringSize * _clickScale.value,
                    height: _ringSize * _clickScale.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _withAlpha(accentColor, _clickOpacity.value),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

            // Additional glow on hover
            if (isHovering)
              Positioned(
                left: position.dx - 30,
                top: position.dy - 30,
                child: IgnorePointer(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _withAlpha(accentColor, 0.15),
                          _withAlpha(accentColor, 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Wrapper widget that detects hover and updates cursor state
class CursorHoverDetector extends StatefulWidget {
  final Widget child;
  final CursorState hoverState;
  final Color? customColor;
  final bool enableMagnetic;
  final double magneticStrength;

  const CursorHoverDetector({
    super.key,
    required this.child,
    this.hoverState = CursorState.hovering,
    this.customColor,
    this.enableMagnetic = false,
    this.magneticStrength = 0.3,
  });

  @override
  State<CursorHoverDetector> createState() => _CursorHoverDetectorState();
}

class _CursorHoverDetectorState extends State<CursorHoverDetector> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Only apply on web
    if (!kIsWeb) {
      return widget.child;
    }

    return MouseRegion(
      key: _key,
      cursor: SystemMouseCursors.none,
      onEnter: (_) => _onEnter(context),
      onExit: (_) => _onExit(context),
      onHover: widget.enableMagnetic ? (event) => _onHover(context, event) : null,
      child: widget.child,
    );
  }

  void _onEnter(BuildContext context) {
    final provider = CursorScope.maybeOf(context);
    if (provider != null) {
      provider.setState(widget.hoverState);
      if (widget.customColor != null) {
        provider.setCustomColor(widget.customColor);
      }
    }
  }

  void _onExit(BuildContext context) {
    final provider = CursorScope.maybeOf(context);
    if (provider != null) {
      provider.setState(CursorState.normal);
      provider.setCustomColor(null);
      provider.setMagneticTarget(null);
    }
  }

  void _onHover(BuildContext context, PointerHoverEvent event) {
    if (!widget.enableMagnetic) return;

    final provider = CursorScope.maybeOf(context);
    if (provider == null) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final center = renderBox.localToGlobal(
        Offset(renderBox.size.width / 2, renderBox.size.height / 2),
      );

      // Calculate magnetic pull towards center
      final cursorPos = event.position;
      final magneticPos = Offset.lerp(
        cursorPos,
        center,
        widget.magneticStrength,
      );

      if (magneticPos != null) {
        provider.setMagneticTarget(magneticPos);
      }
    }
  }
}

/// A text field wrapper that changes cursor to text mode
class CursorTextField extends StatelessWidget {
  final Widget child;

  const CursorTextField({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CursorHoverDetector(
      hoverState: CursorState.text,
      child: child,
    );
  }
}

/// A link wrapper that changes cursor to link mode
class CursorLink extends StatelessWidget {
  final Widget child;
  final Color? customColor;
  final bool enableMagnetic;

  const CursorLink({
    super.key,
    required this.child,
    this.customColor,
    this.enableMagnetic = true,
  });

  @override
  Widget build(BuildContext context) {
    return CursorHoverDetector(
      hoverState: CursorState.link,
      customColor: customColor,
      enableMagnetic: enableMagnetic,
      magneticStrength: 0.2,
      child: child,
    );
  }
}
