import 'package:flutter/material.dart';
import 'app.dart';
import 'core/utils/web_performance.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize web-specific performance optimizations
  WebPerformance.initialize();

  setupDependencies();
  runApp(const PortfolioApp());
}
