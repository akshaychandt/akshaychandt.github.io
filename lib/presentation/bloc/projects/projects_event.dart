import 'package:equatable/equatable.dart';
import '../../../data/models/project_model.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjectsEvent extends ProjectsEvent {
  const LoadProjectsEvent();
}

class FilterProjectsEvent extends ProjectsEvent {
  final ProjectCategory category;

  const FilterProjectsEvent(this.category);

  @override
  List<Object?> get props => [category];
}
