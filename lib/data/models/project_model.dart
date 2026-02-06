import 'package:equatable/equatable.dart';

enum ProjectCategory { all, crm, pos, assetManagement, service, openSource, other }

class ProjectModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final List<String> techStack;
  final ProjectCategory category;
  final String? imageUrl;
  final String? liveUrl;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.techStack,
    required this.category,
    this.imageUrl,
    this.liveUrl,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        features,
        techStack,
        category,
        imageUrl,
        liveUrl,
        githubUrl,
        playStoreUrl,
        appStoreUrl,
      ];
}
