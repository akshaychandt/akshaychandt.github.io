import 'package:flutter/material.dart';

/// Cursor state types for different hover states
enum CursorState {
  normal,
  hovering,
  clicking,
  text,
  link,
}

/// Provider for managing global cursor state across the application
class CursorProvider extends ChangeNotifier {
  // Current mouse position
  Offset _position = Offset.zero;
  Offset get position => _position;

  // Target position for smooth interpolation
  Offset _targetPosition = Offset.zero;
  Offset get targetPosition => _targetPosition;

  // Current cursor state
  CursorState _state = CursorState.normal;
  CursorState get state => _state;

  // Is cursor visible (only on web/desktop)
  bool _isVisible = false;
  bool get isVisible => _isVisible;

  // Magnetic target position (for button attraction)
  Offset? _magneticTarget;
  Offset? get magneticTarget => _magneticTarget;

  // Custom cursor color (for specific elements)
  Color? _customColor;
  Color? get customColor => _customColor;

  // Click animation trigger
  bool _isClicking = false;
  bool get isClicking => _isClicking;

  // Trail positions for trailing effect
  final List<Offset> _trailPositions = [];
  List<Offset> get trailPositions => List.unmodifiable(_trailPositions);

  static const int maxTrailLength = 8;

  /// Update cursor position
  void updatePosition(Offset newPosition) {
    _targetPosition = newPosition;

    // Add to trail
    _trailPositions.insert(0, newPosition);
    if (_trailPositions.length > maxTrailLength) {
      _trailPositions.removeLast();
    }

    if (!_isVisible) {
      _isVisible = true;
    }
    notifyListeners();
  }

  /// Lerp the actual position towards target (called per frame)
  void lerpPosition(double t) =>
      _position = Offset.lerp(_position, _targetPosition, t) ?? _targetPosition;

  /// Set cursor state
  void setState(CursorState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Set magnetic target for attraction effect
  void setMagneticTarget(Offset? target) {
    _magneticTarget = target;
    notifyListeners();
  }

  /// Set custom color for cursor
  void setCustomColor(Color? color) {
    _customColor = color;
    notifyListeners();
  }

  /// Trigger click animation
  void triggerClick() {
    _isClicking = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 400), () {
      _isClicking = false;
      notifyListeners();
    });
  }

  /// Hide cursor
  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  /// Show cursor
  void show() {
    _isVisible = true;
    notifyListeners();
  }
}

/// InheritedWidget for providing cursor state down the tree
class CursorScope extends InheritedNotifier<CursorProvider> {
  const CursorScope({
    super.key,
    required CursorProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static CursorProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CursorScope>();
    assert(scope != null, 'CursorScope not found in widget tree');
    return scope!.notifier!;
  }

  static CursorProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CursorScope>()?.notifier;
}
