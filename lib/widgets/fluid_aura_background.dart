import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FluidAuraBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;

  const FluidAuraBackground({super.key, required this.child, this.colors});

  @override
  State<FluidAuraBackground> createState() => _FluidAuraBackgroundState();
}

class _FluidAuraBackgroundState extends State<FluidAuraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_AuraCircle> _auras = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generamos 5 auras iniciales con posiciones y velocidades aleatorias
    for (int i = 0; i < 6; i++) {
      _auras.add(_AuraCircle(
        color: (widget.colors ?? [
          AppTheme.primaryBlue.withOpacity(0.3),
          AppTheme.primaryGreen.withOpacity(0.3),
          const Color(0xFFE1F5FE),
        ])[_random.nextInt((widget.colors?.length ?? 3))],
        radius: 150 + _random.nextDouble() * 200,
        position: Offset(_random.nextDouble(), _random.nextDouble()),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.002,
          (_random.nextDouble() - 0.5) * 0.002,
        ),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Actualizar posiciones de las auras
        for (var aura in _auras) {
          aura.update();
        }

        return Stack(
          children: [
            // El fondo fluido con CustomPainter
            CustomPaint(
              painter: _AuraPainter(_auras),
              size: Size.infinite,
            ),
            // Capa de desenfoque para dar efecto "Three.js/Aura"
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            //   child: Container(color: Colors.transparent),
            // ),
            widget.child,
          ],
        );
      },
    );
  }
}

class _AuraCircle {
  final Color color;
  final double radius;
  Offset position; // Posición normalizada (0.0 a 1.0)
  Offset velocity;

  _AuraCircle({
    required this.color,
    required this.radius,
    required this.position,
    required this.velocity,
  });

  void update() {
    position += velocity;
    
    // Rebote simple en los bordes
    if (position.dx < -0.2 || position.dx > 1.2) velocity = Offset(-velocity.dx, velocity.dy);
    if (position.dy < -0.2 || position.dy > 1.2) velocity = Offset(velocity.dx, -velocity.dy);
  }
}

class _AuraPainter extends CustomPainter {
  final List<_AuraCircle> auras;

  _AuraPainter(this.auras);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    for (var aura in auras) {
      final center = Offset(aura.position.dx * size.width, aura.position.dy * size.height);
      
      final gradient = RadialGradient(
        colors: [
          aura.color,
          aura.color.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: aura.radius));

      paint.shader = gradient;
      canvas.drawCircle(center, aura.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
