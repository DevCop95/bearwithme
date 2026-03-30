import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LumeAvatar extends StatefulWidget {
  final double moodScore; // 0.0 (triste) a 1.0 (feliz)
  final double size;

  const LumeAvatar({super.key, required this.moodScore, this.size = 200});

  @override
  State<LumeAvatar> createState() => _LumeAvatarState();
}

class _LumeAvatarState extends State<LumeAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definimos los colores basados en el mood
    // Triste: Azul Profundo | Calma: Verde Aqua | Feliz: Oro/Cian
    final Color baseColor = Color.lerp(
      const Color(0xFF1B4965), // Triste (Azul)
      AppTheme.primaryBlue,    // Feliz (Cian)
      widget.moodScore,
    )!;

    final Color accentColor = Color.lerp(
      const Color(0xFF62B1A6), // Triste
      const Color(0xFFFFD166), // Feliz (Dorado)
      widget.moodScore,
    )!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _LumePainter(
            animationValue: _controller.value,
            baseColor: baseColor,
            accentColor: accentColor,
            energy: 0.5 + (widget.moodScore * 1.5), // Más energía si está feliz
          ),
        );
      },
    );
  }
}

class _LumePainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;
  final Color accentColor;
  final double energy;

  _LumePainter({
    required this.animationValue,
    required this.baseColor,
    required this.accentColor,
    required this.energy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    // Dibujamos varias capas de "luz" para simular profundidad 3D
    for (int i = 0; i < 4; i++) {
      final t = (animationValue + (i * 0.25)) % 1.0;
      final wave = sin(t * pi * 2);
      
      // Desplazamiento orgánico
      final offset = Offset(
        sin(t * pi * 2 + i) * 10 * energy,
        cos(t * pi * 2 + i * 2) * 10 * energy,
      );

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            accentColor.withOpacity(0.6 - (i * 0.1)),
            baseColor.withOpacity(0),
          ],
          stops: const [0.2, 1.0],
        ).createShader(Rect.fromCircle(center: center + offset, radius: radius + (wave * 5)));

      canvas.drawCircle(center + offset, radius + (wave * 10 * energy), paint);
    }

    // Núcleo brillante
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          accentColor.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.4));
    
    canvas.drawCircle(center, radius * 0.4, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
