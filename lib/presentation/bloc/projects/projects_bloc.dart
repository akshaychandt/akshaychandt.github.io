import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/resume_data.dart';
import '../../../data/models/project_model.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(const ProjectsState()) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<FilterProjectsEvent>(_onFilterProjects);
  }

  void _onLoadProjects(
    LoadProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) {
    emit(state.copyWith(isLoading: true));

    final projects = ResumeData.projects;

    emit(state.copyWith(
      allProjects: projects,
      filteredProjects: projects,
      isLoading: false,
    ));
  }

  void _onFilterProjects(
    FilterProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) {
    final filtered = event.category == ProjectCategory.all
        ? state.allProjects
        : state.allProjects
            .where((project) => project.category == event.category)
            .toList();

    emit(state.copyWith(
      filteredProjects: filtered,
      selectedCategory: event.category,
    ));
  }
}
