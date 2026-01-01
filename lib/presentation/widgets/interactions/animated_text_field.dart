import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// An enhanced TextFormField with micro-interactions including:
/// - Smooth focus animations
/// - Error shake effect
/// - Icon animations
/// - Character count animation
/// - Success state feedback
class AnimatedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool showCharacterCount;
  final FocusNode? focusNode;
  final bool autofocus;

  const AnimatedTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.showCharacterCount = false,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with TickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _focusController;
  late AnimationController _shakeController;
  late AnimationController _iconController;
  late Animation<double> _focusAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _iconAnimation;

  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    // Focus animation controller
    _focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeOut,
    ));

    // Shake animation controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -5), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -5, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    // Icon animation controller
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _iconAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusController.dispose();
    _shakeController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _focusController.forward();
      _iconController.forward().then((_) => _iconController.reverse());
      HapticFeedback.selectionClick();
    } else {
      _focusController.reverse();
    }
  }

  void _triggerShake() {
    HapticFeedback.mediumImpact();
    _shakeController.forward(from: 0);
  }

  String? _handleValidation(String? value) {
    final error = widget.validator?.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final hadError = _hasError;
        setState(() {
          _hasError = error != null;
          _errorText = error;
        });
        if (_hasError && !hadError) {
          _triggerShake();
        }
      }
    });
    return error;
  }

  void _onTextChanged(String value) {
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated label
          if (widget.labelText != null) ...[
            AnimatedBuilder(
              animation: _focusAnimation,
              builder: (context, child) {
                return Text(
                  widget.labelText!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _hasError
                        ? errorColor
                        : Color.lerp(
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            primaryColor,
                            _focusAnimation.value,
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],

          // Text field with animated border
          AnimatedBuilder(
            animation: _focusAnimation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isFocused && !_hasError
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: child,
              );
            },
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              autofocus: widget.autofocus,
              validator: _handleValidation,
              onChanged: _onTextChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              buildCounter: widget.maxLength != null ? _buildCounter : null,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null
                    ? AnimatedBuilder(
                        animation: _iconAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _iconAnimation.value,
                            child: Icon(
                              widget.prefixIcon,
                              color: _hasError
                                  ? errorColor
                                  : _isFocused
                                      ? primaryColor
                                      : isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                            ),
                          );
                        },
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? _buildSuffixIcon(isDark, primaryColor)
                    : null,
                errorText: null, // We handle error display ourselves
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _hasError
                        ? errorColor
                        : isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _hasError ? errorColor : primaryColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Animated error text
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: _hasError && _errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 14,
                          color: errorColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: TextStyle(
                              fontSize: 12,
                              color: errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuffixIcon(bool isDark, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onSuffixTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          widget.suffixIcon,
          color: _isFocused
              ? primaryColor
              : isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    if (!widget.showCharacterCount || maxLength == null) return null;

    final theme = Theme.of(context);
    final remaining = maxLength - currentLength;
    final isNearLimit = remaining <= maxLength * 0.1;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 12,
        color: isNearLimit
            ? theme.colorScheme.error
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.normal,
      ),
      child: Text('$currentLength / $maxLength'),
    );
  }
}

/// A text field specifically designed for password input with visibility toggle.
class AnimatedPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AnimatedPasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<AnimatedPasswordField> createState() => _AnimatedPasswordFieldState();
}

class _AnimatedPasswordFieldState extends State<AnimatedPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      prefixIcon: Icons.lock_outline,
      suffixIcon: _obscureText ? Icons.visibility_off : Icons.visibility,
      onSuffixTap: _toggleVisibility,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
