import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToSectionEvent extends NavigationEvent {
  final int sectionIndex;

  const NavigateToSectionEvent(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}

class UpdateCurrentSectionEvent extends NavigationEvent {
  final int sectionIndex;

  const UpdateCurrentSectionEvent(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}
