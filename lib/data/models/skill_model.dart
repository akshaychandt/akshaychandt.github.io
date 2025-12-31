import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SkillCategory extends Equatable {
  final String name;
  final IconData icon;
  final List<SkillModel> skills;

  const SkillCategory({
    required this.name,
    required this.icon,
    required this.skills,
  });

  @override
  List<Object?> get props => [name, icon, skills];
}

class SkillModel extends Equatable {
  final String name;
  final double proficiency; // 0.0 to 1.0
  final String? iconUrl;

  const SkillModel({
    required this.name,
    this.proficiency = 0.8,
    this.iconUrl,
  });

  @override
  List<Object?> get props => [name, proficiency, iconUrl];
}
