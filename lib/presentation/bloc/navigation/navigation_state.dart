import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int currentSection;
  final bool isScrolling;

  const NavigationState({
    this.currentSection = 0,
    this.isScrolling = false,
  });

  NavigationState copyWith({
    int? currentSection,
    bool? isScrolling,
  }) {
    return NavigationState(
      currentSection: currentSection ?? this.currentSection,
      isScrolling: isScrolling ?? this.isScrolling,
    );
  }

  @override
  List<Object?> get props => [currentSection, isScrolling];
}
