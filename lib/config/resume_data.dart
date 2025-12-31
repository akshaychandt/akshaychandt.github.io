import 'package:flutter/material.dart';
import '../data/models/experience_model.dart';
import '../data/models/project_model.dart';
import '../data/models/skill_model.dart';
import '../data/models/testimonial_model.dart';

class ResumeData {
  ResumeData._();

  // Skills Data
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      name: 'Mobile & Cross-Platform',
      icon: Icons.phone_android,
      skills: [
        SkillModel(name: 'Flutter', proficiency: 0.95),
        SkillModel(name: 'Dart', proficiency: 0.95),
        SkillModel(name: 'Android', proficiency: 0.85),
        SkillModel(name: 'iOS', proficiency: 0.85),
        SkillModel(name: 'Windows', proficiency: 0.75),
        SkillModel(name: 'macOS', proficiency: 0.75),
        SkillModel(name: 'Web', proficiency: 0.80),
      ],
    ),
    SkillCategory(
      name: 'State Management',
      icon: Icons.account_tree,
      skills: [
        SkillModel(name: 'Stacked MVVM', proficiency: 0.90),
        SkillModel(name: 'Provider', proficiency: 0.90),
        SkillModel(name: 'Riverpod', proficiency: 0.85),
        SkillModel(name: 'BLoC', proficiency: 0.85),
        SkillModel(name: 'GetX', proficiency: 0.80),
      ],
    ),
    SkillCategory(
      name: 'Backend & API',
      icon: Icons.cloud,
      skills: [
        SkillModel(name: 'REST API', proficiency: 0.90),
        SkillModel(name: 'SAP Service Layer', proficiency: 0.85),
        SkillModel(name: 'SAP Gateway', proficiency: 0.85),
        SkillModel(name: 'Firebase', proficiency: 0.90),
        SkillModel(name: 'PHP (CodeIgniter)', proficiency: 0.75),
        SkillModel(name: 'PHP (Laravel)', proficiency: 0.70),
      ],
    ),
    SkillCategory(
      name: 'Database',
      icon: Icons.storage,
      skills: [
        SkillModel(name: 'SQLite', proficiency: 0.90),
        SkillModel(name: 'Hive', proficiency: 0.85),
        SkillModel(name: 'Cloud Firestore', proficiency: 0.85),
        SkillModel(name: 'MySQL', proficiency: 0.80),
        SkillModel(name: 'PostgreSQL', proficiency: 0.75),
      ],
    ),
    SkillCategory(
      name: 'Architecture & Tools',
      icon: Icons.architecture,
      skills: [
        SkillModel(name: 'MVVM', proficiency: 0.90),
        SkillModel(name: 'MVC', proficiency: 0.85),
        SkillModel(name: 'Dependency Injection', proficiency: 0.90),
        SkillModel(name: 'Git/GitHub', proficiency: 0.90),
        SkillModel(name: 'Postman', proficiency: 0.85),
      ],
    ),
    SkillCategory(
      name: 'Advanced Features',
      icon: Icons.auto_awesome,
      skills: [
        SkillModel(name: 'Push Notifications', proficiency: 0.90),
        SkillModel(name: 'Background Location', proficiency: 0.85),
        SkillModel(name: 'Geo-fencing', proficiency: 0.85),
        SkillModel(name: 'Deep Linking', proficiency: 0.85),
        SkillModel(name: 'Offline Data Sync', proficiency: 0.90),
        SkillModel(name: 'Payment Gateway', proficiency: 0.80),
        SkillModel(name: 'Biometric Auth', proficiency: 0.85),
      ],
    ),
  ];

  // Experience Data
  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      id: '1',
      company: 'FieldNXT Service Solutions Pvt Ltd',
      role: 'Flutter Developer (Senior)',
      location: 'Technopark, Trivandrum',
      startDate: 'August 2022',
      isCurrent: true,
      responsibilities: [
        'Lead the Flutter development team building enterprise solutions for B2B clients, managing complete project lifecycle from requirements analysis to production deployment across mobile, web, and desktop platforms',
        'Developed and maintained 20+ production-ready applications including CRM systems, POS applications, field service portals, and asset management solutions serving enterprise clients',
        'Architected offline-capable mobile applications with real-time data synchronization and custom conflict resolution logic',
        'Integrated SAP Service Layer, Gateway APIs enabling seamless ERP integration with real-time bidirectional data sync, in-app Gmail integration and Google Calendar integration',
        'Implemented complex features including background location tracking for iOS, queue-based offline sync, Firebase Cloud Messaging for push notifications, deep linking, Firebase Authentication, Google Analytics, Crashlytics, payment gateway integration, and biometric authentication',
        'Leveraged AI-powered development tools including Cursor, Claude, GitHub Copilot, Tabnine, and Windsurf to accelerate development workflows and improve code quality',
        'Mentored junior developers conducting code reviews to enforce best practices and maintain code quality standards',
        'Independently managed end-to-end app publishing process to Google Play Store and Apple App Store, including compliance requirements and release management',
      ],
    ),
    ExperienceModel(
      id: '2',
      company: 'Futura Labs LLP',
      role: 'Flutter Developer',
      location: 'Calicut, Kerala',
      startDate: 'April 2022',
      endDate: 'July 2022',
      responsibilities: [
        'Developed full-stack mobile applications using Flutter and PHP, successfully delivering multiple projects within timelines',
        'Mentored a team of 4-5 developers and interns, providing technical guidance and conducting training sessions on Flutter best practices',
        'Built and deployed client projects including HouseHold management, KisanSeva agricultural platform, and PetSpoter pet care app',
        'Implemented state management solutions (Provider, GetX, BLoC) and IoT device integrations based on project requirements',
        'Collaborated with design teams to implement responsive UI/UX designs and ensured cross-platform compatibility',
      ],
    ),
    ExperienceModel(
      id: '3',
      company: 'Futura Labs LLP & Eolas Technologies',
      role: 'Software Developer',
      location: 'Kerala & Puducherry',
      startDate: 'August 2021',
      endDate: 'March 2022',
      responsibilities: [
        'Developed mobile applications using Flutter and web applications using PHP (CodeIgniter framework) and jQuery',
        'Built Time Management System web application and contributed to maintenance of existing client projects',
        'Collaborated with the teams to deliver functional applications with state management patterns and Firebase cloud services',
        'Learned and applied REST API integration, UI/UX design, and Flutter development patterns in production environments',
      ],
    ),
  ];

  // Projects Data
  static const List<ProjectModel> projects = [
    ProjectModel(
      id: '1',
      title: 'The Wine Source CRM',
      subtitle: 'Enterprise CRM Application with SAP Integration',
      description:
          'Comprehensive CRM system for managing sales pipeline including opportunities, quotations, orders, invoices, and customer relationships using Stacked MVVM architecture.',
      features: [
        'Integrated SAP Service Layer and Gateway APIs for real-time bidirectional enterprise data synchronization with backend ERP systems',
        'Built Gmail clone for in-app email management, Google Calendar integration for event synchronization',
        'Google Maps integration for nearby wine shop opportunities with location-based filtering',
        'Implemented background location tracking with geofencing, Firebase push notifications, GPS tracking',
        'SQLite for complete offline functionality with intelligent data sync',
      ],
      techStack: [
        'Flutter',
        'Dart',
        'Stacked MVVM',
        'SAP Service Layer',
        'SAP Gateway APIs',
        'Firebase',
        'SQLite',
        'Google Maps API',
        'Gmail API',
        'Google Calendar API',
      ],
      category: ProjectCategory.crm,
    ),
    ProjectModel(
      id: '2',
      title: 'Vansale - Point of Sale',
      subtitle: 'Automated POS System with Offline Capability',
      description:
          'Comprehensive automated POS system with attendance tracking, route planning, stock management, invoicing, payment collection, and thermal printing.',
      features: [
        'Designed offline-capable architecture with queue-based synchronization',
        'Geo-fencing for automatic check-in/check-out',
        'Implemented geo-mapping for route optimization',
        'Background location tracking for field force management and compliance',
        'Thermal printer integration for receipt printing',
      ],
      techStack: [
        'Flutter',
        'Dart',
        'Stacked MVVM',
        'Firebase',
        'Hive',
        'Background Location Services',
        'Geo-fencing APIs',
        'Thermal Printer SDK',
      ],
      category: ProjectCategory.pos,
    ),
    ProjectModel(
      id: '3',
      title: 'ATS - Asset Tracking System',
      subtitle: 'Enterprise Asset Management Solution',
      description:
          'Asset management application for QR/barcode tagging, comprehensive asset registration, real-time tracking, and periodic lifecycle auditing.',
      features: [
        'Implemented scheduled maintenance management and asset movement tracking',
        'Automated depreciation calculation and disposal workflows',
        'Integrated Firebase notifications and GPS tracking',
        'Geo-mapping for asset visibility and comprehensive audit trails',
        'QR/Barcode scanning for quick asset identification',
      ],
      techStack: [
        'Flutter',
        'Dart',
        'Stacked MVVM',
        'Firebase',
        'SQLite',
        'QR/Barcode Scanner',
        'Google Maps API',
        'Push Notifications',
      ],
      category: ProjectCategory.assetManagement,
    ),
  ];

  // Testimonials Data (Placeholder - can be updated with real testimonials)
  static const List<TestimonialModel> testimonials = [
    TestimonialModel(
      id: '1',
      name: 'Tech Lead',
      role: 'Project Manager',
      company: 'FieldNXT',
      content:
          'Akshay is an exceptional Flutter developer who consistently delivers high-quality code. His expertise in offline architecture and SAP integration has been invaluable to our enterprise projects.',
    ),
    TestimonialModel(
      id: '2',
      name: 'Senior Developer',
      role: 'Team Lead',
      company: 'Futura Labs',
      content:
          'Working with Akshay was a great experience. His mentoring skills helped our junior developers grow rapidly, and his technical solutions were always well-thought-out and efficient.',
    ),
    TestimonialModel(
      id: '3',
      name: 'Product Owner',
      role: 'Business Analyst',
      company: 'Client Company',
      content:
          'The applications Akshay developed for us exceeded our expectations. The offline capabilities and seamless sync features have transformed how our field teams operate.',
    ),
  ];

  // Stats
  static const Map<String, String> stats = {
    'years': '4+',
    'yearsLabel': 'Years Experience',
    'apps': '20+',
    'appsLabel': 'Apps Published',
    'mentored': '15+',
    'mentoredLabel': 'Developers Mentored',
    'platforms': '6',
    'platformsLabel': 'Platforms Supported',
  };
}
