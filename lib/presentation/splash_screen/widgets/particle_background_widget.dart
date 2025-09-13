import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleBackgroundWidget extends StatefulWidget {
  const ParticleBackgroundWidget({super.key});

  @override
  State<ParticleBackgroundWidget> createState() =>
      _ParticleBackgroundWidgetState();
}

class _ParticleBackgroundWidgetState extends State<ParticleBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Particle> _particles;
  final int _particleCount = 50;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    _particles = List.generate(_particleCount, (index) {
      return Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 4 + 1,
        speed: math.Random().nextDouble() * 0.02 + 0.01,
        opacity: math.Random().nextDouble() * 0.6 + 0.2,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particles, _animationController.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Update particle position
      particle.y = (particle.y + particle.speed) % 1.0;

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      paint.color = Colors.white.withValues(alpha: particle.opacity * 0.5);

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
