import 'package:get_it/get_it.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/navigation/navigation_bloc.dart';
import 'presentation/bloc/projects/projects_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // BLoCs
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());
  getIt.registerFactory<NavigationBloc>(() => NavigationBloc());
  getIt.registerFactory<ProjectsBloc>(() => ProjectsBloc());
}
