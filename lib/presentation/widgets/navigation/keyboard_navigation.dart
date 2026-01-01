import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/navigation/navigation_bloc.dart';
import '../../bloc/navigation/navigation_state.dart';

class KeyboardNavigationHandler extends StatefulWidget {
  final Widget child;
  final int sectionCount;
  final void Function(int index) onNavigateToSection;

  const KeyboardNavigationHandler({
    super.key,
    required this.child,
    required this.sectionCount,
    required this.onNavigateToSection,
  });

  @override
  State<KeyboardNavigationHandler> createState() =>
      _KeyboardNavigationHandlerState();
}

class _KeyboardNavigationHandlerState extends State<KeyboardNavigationHandler> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final currentSection =
        context.read<NavigationBloc>().state.currentSection;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.pageDown:
        if (currentSection < widget.sectionCount - 1) {
          widget.onNavigateToSection(currentSection + 1);
        }
        break;
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.pageUp:
        if (currentSection > 0) {
          widget.onNavigateToSection(currentSection - 1);
        }
        break;
      case LogicalKeyboardKey.home:
        widget.onNavigateToSection(0);
        break;
      case LogicalKeyboardKey.end:
        widget.onNavigateToSection(widget.sectionCount - 1);
        break;
      case LogicalKeyboardKey.digit1:
      case LogicalKeyboardKey.numpad1:
        widget.onNavigateToSection(0);
        break;
      case LogicalKeyboardKey.digit2:
      case LogicalKeyboardKey.numpad2:
        if (widget.sectionCount > 1) widget.onNavigateToSection(1);
        break;
      case LogicalKeyboardKey.digit3:
      case LogicalKeyboardKey.numpad3:
        if (widget.sectionCount > 2) widget.onNavigateToSection(2);
        break;
      case LogicalKeyboardKey.digit4:
      case LogicalKeyboardKey.numpad4:
        if (widget.sectionCount > 3) widget.onNavigateToSection(3);
        break;
      case LogicalKeyboardKey.digit5:
      case LogicalKeyboardKey.numpad5:
        if (widget.sectionCount > 4) widget.onNavigateToSection(4);
        break;
      case LogicalKeyboardKey.digit6:
      case LogicalKeyboardKey.numpad6:
        if (widget.sectionCount > 5) widget.onNavigateToSection(5);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: widget.child,
        );
      },
    );
  }
}
