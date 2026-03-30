import 'package:flutter/material.dart';
import 'fluid_aura_background.dart';

class DynamicBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const DynamicBackground({super.key, required this.child, this.colors});

  @override
  Widget build(BuildContext context) {
    return FluidAuraBackground(
      colors: colors,
      child: child,
    );
  }
}
