import 'package:equatable/equatable.dart';
import '../../../data/models/project_model.dart';

class ProjectsState extends Equatable {
  final List<ProjectModel> allProjects;
  final List<ProjectModel> filteredProjects;
  final ProjectCategory selectedCategory;
  final bool isLoading;

  const ProjectsState({
    this.allProjects = const [],
    this.filteredProjects = const [],
    this.selectedCategory = ProjectCategory.all,
    this.isLoading = false,
  });

  ProjectsState copyWith({
    List<ProjectModel>? allProjects,
    List<ProjectModel>? filteredProjects,
    ProjectCategory? selectedCategory,
    bool? isLoading,
  }) =>
      ProjectsState(
        allProjects: allProjects ?? this.allProjects,
        filteredProjects: filteredProjects ?? this.filteredProjects,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [
        allProjects,
        filteredProjects,
        selectedCategory,
        isLoading,
      ];
}
