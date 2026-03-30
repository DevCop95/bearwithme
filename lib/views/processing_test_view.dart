import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../widgets/dynamic_background.dart';

class ProcessingTestView extends StatefulWidget {
  final String personalityType;
  const ProcessingTestView({super.key, required this.personalityType});

  @override
  State<ProcessingTestView> createState() => _ProcessingTestViewState();
}

class _ProcessingTestViewState extends State<ProcessingTestView> {
  @override
  void initState() {
    super.initState();
    // Simular tiempo de procesamiento analítico
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context, 
          '/home', 
          arguments: {'personalityType': widget.personalityType}
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la App MUCHO MÁS GRANDE e Impactante
                FadeInDown(
                  duration: const Duration(seconds: 1),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.2),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 220, // Logo mucho más grande
                      width: 220,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.psychology_outlined,
                        size: 180,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Analizando tus respuestas...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'Estamos construyendo tu perfil psicológico basado en las 10 dimensiones evaluadas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textLight.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                
                // Barra de carga premium
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: AppTheme.primaryBlue,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sincronizando con el Guía Emocional',
                          style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
