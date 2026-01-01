import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateToSectionEvent>(_onNavigateToSection);
    on<UpdateCurrentSectionEvent>(_onUpdateCurrentSection);
  }

  void _onNavigateToSection(NavigateToSectionEvent event, Emitter<NavigationState> emit) =>
      emit(state.copyWith(currentSection: event.sectionIndex, isScrolling: true));

  void _onUpdateCurrentSection(UpdateCurrentSectionEvent event, Emitter<NavigationState> emit) =>
      emit(state.copyWith(
        currentSection: state.isScrolling ? state.currentSection : event.sectionIndex,
        isScrolling: false,
      ));
}
