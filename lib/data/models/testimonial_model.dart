import 'package:equatable/equatable.dart';

class TestimonialModel extends Equatable {
  final String id;
  final String name;
  final String role;
  final String company;
  final String content;
  final String? avatarUrl;

  const TestimonialModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.content,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, role, company, content, avatarUrl];
}
