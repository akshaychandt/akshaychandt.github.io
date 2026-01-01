import 'package:equatable/equatable.dart';

class ExperienceModel extends Equatable {
  final String id;
  final String company;
  final String role;
  final String location;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final List<String> responsibilities;
  final String? logoUrl;

  const ExperienceModel({
    required this.id,
    required this.company,
    required this.role,
    required this.location,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.responsibilities,
    this.logoUrl,
  });

  String get duration => isCurrent ? '$startDate - Present' : '$startDate - $endDate';

  @override
  List<Object?> get props => [
        id,
        company,
        role,
        location,
        startDate,
        endDate,
        isCurrent,
        responsibilities,
        logoUrl,
      ];
}
