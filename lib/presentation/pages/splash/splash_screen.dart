import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _logoController;
  late AnimationController _progressController;
  late List<Particle> _particles;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();

    _particles = List.generate(30, (_) => Particle.random());

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _showContent = true);
      _logoController.forward();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      _progressController.forward();
    }

    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Animated particle background
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                  primaryColor: AppColors.darkPrimary.withValues(alpha: 0.3),
                  accentColor: AppColors.darkAccent.withValues(alpha: 0.2),
                ),
                size: Size.infinite,
              );
            },
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  backgroundColor.withValues(alpha: 0.3),
                  backgroundColor,
                ],
              ),
            ),
          ),

          // Main content
          Center(
            child: _showContent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo/initials
                      _buildAnimatedLogo(textColor),
                      const SizedBox(height: 32),

                      // Name text
                      Text(
                        'Akshay Chand T',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          letterSpacing: 2,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 400),
                            duration: const Duration(milliseconds: 600),
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            delay: const Duration(milliseconds: 400),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                          ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Flutter Developer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: secondaryTextColor,
                          letterSpacing: 4,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 600),
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                          ),

                      const SizedBox(height: 48),

                      // Loading indicator
                      _buildLoadingIndicator(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo(Color textColor) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.5 + (_logoController.value * 0.5),
          child: Opacity(
            opacity: _logoController.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.darkPrimary,
                    AppColors.darkAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkPrimary.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'AC',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, _) {
        return Column(
          children: [
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressController.value,
                  backgroundColor: AppColors.darkSurface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.lerp(
                      AppColors.darkPrimary,
                      AppColors.darkAccent,
                      _progressController.value,
                    )!,
                  ),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkTextSecondary,
                letterSpacing: 2,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .fadeIn(duration: const Duration(milliseconds: 600))
                .then()
                .fadeOut(duration: const Duration(milliseconds: 600)),
          ],
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  factory Particle.random() {
    final random = math.Random();
    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 3 + 1,
      speedX: (random.nextDouble() - 0.5) * 0.02,
      speedY: (random.nextDouble() - 0.5) * 0.02,
      opacity: random.nextDouble() * 0.5 + 0.2,
    );
  }

  void update(double progress) {
    x += speedX;
    y += speedY;

    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color primaryColor;
  final Color accentColor;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(progress);

      final paint = Paint()
        ..color = (particles.indexOf(particle) % 2 == 0 ? primaryColor : accentColor)
            .withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }

    // Draw connecting lines between close particles
    final linePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];
        final dx = (p1.x - p2.x) * size.width;
        final dy = (p1.y - p2.y) * size.height;
        final distance = math.sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          linePaint.color = primaryColor.withValues(
            alpha: (1 - distance / 100) * 0.15,
          );
          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
