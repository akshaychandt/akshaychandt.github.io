import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// An animated button with micro-interactions including:
/// - Scale down on press
/// - Gradient shift on hover
/// - Loading state with spinner
/// - Success/error state feedback
/// - Ripple effect on tap
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final IconData? icon;
  final bool isOutlined;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.icon,
    this.isOutlined = false,
    this.width,
    this.height = 52,
    this.borderRadius,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _hoverController;
  late AnimationController _successController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _successAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _successController.forward(from: 0);
      HapticFeedback.mediumImpact();
    }
    if (widget.isError && !oldWidget.isError) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _hoverController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isLoading || widget.onPressed == null) return;
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  void _onHoverEnter(PointerEvent event) {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _onHoverExit(PointerEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return MouseRegion(
      onEnter: _onHoverEnter,
      onExit: _onHoverExit,
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _hoverAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _isHovered ? -2 : 0),
                child: child,
              ),
            );
          },
          child: _buildButton(theme, isDisabled),
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme, bool isDisabled) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    if (widget.isOutlined) {
      return _buildOutlinedButton(theme, isDisabled, borderRadius);
    }
    return _buildFilledButton(theme, isDisabled, borderRadius);
  }

  Widget _buildFilledButton(
    ThemeData theme,
    bool isDisabled,
    BorderRadius borderRadius,
  ) {
    final baseGradient = AppColors.primaryGradient;
    final hoverGradient = AppColors.accentGradient;

    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: isDisabled
                ? LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade500],
                  )
                : LinearGradient(
                    colors: [
                      Color.lerp(
                        baseGradient.colors[0],
                        hoverGradient.colors[0],
                        _hoverAnimation.value,
                      )!,
                      Color.lerp(
                        baseGradient.colors[1],
                        hoverGradient.colors[1],
                        _hoverAnimation.value,
                      )!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: _isHovered && !isDisabled
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: child,
        );
      },
      child: _buildButtonContent(theme, Colors.white),
    );
  }

  Widget _buildOutlinedButton(
    ThemeData theme,
    bool isDisabled,
    BorderRadius borderRadius,
  ) {
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: isDisabled
              ? Colors.grey.shade400
              : _isHovered
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.5),
          width: _isHovered ? 2 : 1.5,
        ),
        color: _isHovered
            ? primaryColor.withValues(alpha: 0.05)
            : Colors.transparent,
      ),
      child: _buildButtonContent(
        theme,
        isDisabled ? Colors.grey.shade400 : primaryColor,
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme, Color textColor) {
    if (widget.isSuccess) {
      return _buildSuccessContent(textColor);
    }

    if (widget.isError) {
      return _buildErrorContent(theme);
    }

    return Center(
      child: widget.isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSuccessContent(Color textColor) {
    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_successAnimation.value * 0.2),
          child: Opacity(
            opacity: _successAnimation.value,
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: textColor, size: 22),
          const SizedBox(width: 8),
          Text(
            'Success!',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: theme.colorScheme.error, size: 22),
        const SizedBox(width: 8),
        Text(
          'Try Again',
          style: TextStyle(
            color: theme.colorScheme.error,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// A simple icon button with scale animation.
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.tooltip,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = widget.color ?? theme.colorScheme.primary;

    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
          HapticFeedback.lightImpact();
        },
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  (_isHovered
                      ? iconColor.withValues(alpha: 0.1)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: widget.size,
              color: _isHovered ? iconColor : iconColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
